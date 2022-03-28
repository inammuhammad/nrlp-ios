//
//  ReceiverListingViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 22/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

typealias ReceiverListingViewModelOutput = (ReceiverListingViewModel.Output) -> Void

protocol ReceiverListingViewModelProtocol {
    var output: ReceiverListingViewModelOutput? { get set }
    var numberOfRows: Int { get }

    func viewModelWillAppear()
    func getReceiver(at index: Int) -> ReceiverModel
    func didSelectReceiver(indexPath: IndexPath)
    func addReceiverClicked()
}

class ReceiverListingViewModel: ReceiverListingViewModelProtocol {

    var output: ReceiverListingViewModelOutput?

    private var router: ReceiverListingRouter!
    private var service: RemitterReceiverService = RemitterReceiverService()

    private var receivers: [ReceiverModel] = []

    init(with router: ReceiverListingRouter) {
        self.router = router
    }

    func viewModelWillAppear() {
//        receivers.append(ReceiverModel(alias: "TEST", beneficiaryId: 0009, isActive: 1, mobileNo: "03344989898", nicNicop: 87613278632, createdAt: "", updatedAt: "", isDeleted: 0, beneficiaryRelation: "Mother", country: "Pakistan", receiverTypeString: "Remittance sent to CNIC"))
        self.receivers.removeAll()
        self.output?(.showActivityIndicator(show: true))
        service.getReceiverListing { response in
            self.output?(.showActivityIndicator(show: false))
            switch response {
            case .success(let model):
//                var tempData = model.data
//                for i in 0..<tempData.count where i % 2 == 1 {
//                    tempData[i].linkStatus = "LINKED"
//                }
//                self.receivers.append(contentsOf: tempData)
                self.receivers.append(contentsOf: model.data)
                if !(self.receivers.isEmpty) {
                    self.output?(.tableVisibility(show: true))
                } else {
                    self.output?(.tableVisibility(show: false))
                }
                self.output?(.reloadReceivers)
//                if self.receivers.count >= 3 {
//                    self.output?(.addButton(state: false))
//                } else {
//                    self.output?(.addButton(state: true))
//                }
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        }
        
    }

    func didSelectReceiver(indexPath: IndexPath) {
        // MOVE TO DETAIL SCREEN
        let model = receivers[indexPath.row]
        router.navigateToReceiverDetailsScreen(receiver: model)
    }
    
    func addReceiverClicked() {
        // MOVE TO ADD SCREEN
        router.navigateToAddReceiverScreen()
    }

    enum Output {
        case showError(error: APIResponseError)
        case showAlert(alert: AlertViewModel)
        case showActivityIndicator(show: Bool)
        case reloadReceivers
        case tableVisibility(show: Bool)
        case addButton(state: Bool)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

// MARK: DataSource related methods
extension ReceiverListingViewModel {
    var numberOfRows: Int {
        return receivers.count
    }

    func getReceiver(at index: Int) -> ReceiverModel {
        return receivers[index]
    }
}

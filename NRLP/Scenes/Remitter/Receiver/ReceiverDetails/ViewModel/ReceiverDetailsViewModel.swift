//
//  ReceiverDetailsViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 22/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias ReceiverDetailsViewModelOutput = (ReceiverDetailsViewModel.Output) -> Void

protocol ReceiverDetailsViewModelProtocol {
    var output: ReceiverDetailsViewModelOutput? { get set }
    
    var name: String? { get set }
    var cnic: String? { get set }
    var cnicIssueDateString: String? { get set }
    var motherMaidenName: String? { get set }
    var mobileNumber: String? { get set }
    var bankName: String? { get set }
    var bankNumber: String? { get set }
    
    func viewDidLoad()
    func deleteButtonPressed()
}

class ReceiverDetailsViewModel: ReceiverDetailsViewModelProtocol {
    
    var output: ReceiverDetailsViewModelOutput?
    
    private var router: ReceiverDetailsRouter
    private var service: RemitterReceiverService = RemitterReceiverService()
    
    var name: String?
    
    var motherMaidenName: String?
    
    var cnic: String?
    
    var cnicIssueDateString: String?
    
    var country: Country?
    
    var birthPlace: String?
    
    var mobileNumber: String?
    
    var bankName: String?
    
    var bankNumber: String?
    
    private var model: ReceiverModel?
    
    init(router: ReceiverDetailsRouter, model: ReceiverModel) {
        self.router = router
        self.model = model
    }
    
    enum Output {
        // case showDeleteButton(show: Bool)
        case showError(error: APIResponseError)
        case showAlert(alert: AlertViewModel)
        case showActivityIndicator(show: Bool)
        case showBankFields(hidden: Bool)
        case setUser(model: ReceiverModel)
    }
    
    func viewDidLoad() {
        // SHOW BANK FIELDS HERE
//        if model?.linkStatus?.lowercased() ?? "" == "LINKED".lowercased() {
//            self.output?(.showDeleteButton(show: true))
//        } else {
//            self.output?(.showDeleteButton(show: false))
//        }
        
        if model?.receiverType == .bank {
            output?(.showBankFields(hidden: false))
        } else {
            output?(.showBankFields(hidden: true))
        }
        setUser()
    }
    
    private func setUser() {
        guard let recieverModel = model else { return }
        output?(.setUser(model: recieverModel))
    }
    
    func deleteButtonPressed() {
        // DELETE API HERE
        let descriptionString = "Are you sure want to delete the Receiver?".localized
        let model = AlertViewModel(alertHeadingImage: .declineAlert, alertTitle: "Delete Remitter Receiver".localized, alertDescription: descriptionString, primaryButton: AlertActionButtonModel(buttonTitle: "Yes".localized, buttonAction: {
            self.output?(.showActivityIndicator(show: true))
            let cnicToDelete = self.cnic == nil ? (self.model?.formattedReceiverCNIC) : self.cnic
            let formattedCnicToDelete = (cnicToDelete?.replacingOccurrences(of: "-", with: ""))?.replacingOccurrences(of: " ", with: "")
            self.service.deleteReceiver(requestModel: DeleteReceiverRequestModel(cnic: formattedCnicToDelete)) { [weak self] (result) in
                self?.output?(.showActivityIndicator(show: false))
                guard let self = self else { return }
                self.output?(.showActivityIndicator(show: false))
                switch result {
                case .success:
                    let alert = AlertViewModel(alertHeadingImage: .successAlert, alertTitle: "Remittance Receiver Removed", alertDescription: "\(self.model?.receiverName ?? "User") has Been Removed".localized, primaryButton: AlertActionButtonModel(buttonTitle: "Done".localized, buttonAction: {
                        self.router.popToPreviousScreen()
                    }))
                    self.output?(.showAlert(alert: alert))
                case .failure(let error):
                    self.output?(.showError(error: error))
                }
            }
        }), secondaryButton: AlertActionButtonModel(buttonTitle: "No".localized, buttonAction: {
        }))
        self.output?(.showAlert(alert: model))
        
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
    
}

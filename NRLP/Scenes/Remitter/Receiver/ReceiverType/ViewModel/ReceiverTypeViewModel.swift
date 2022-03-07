//
//  ReceiverTypeViewModel.swift
//  
//
//  Created by Bilal Iqbal on 18/02/2022.
//

import Foundation
import UIKit

typealias ReceiverTypeViewModelOutput = (ReceiverTypeViewModel.Output) -> Void

protocol ReceiverTypeViewModelProtocol {
    var output: ReceiverTypeViewModelOutput? { get set }
    var receiverTypeItemPickerViewModel: ItemPickerViewModel { get }
    
    func viewDidLoad()
    func didSelect(receiverType: RemitterReceiverTypePickerItemModel)
    func nextButtonPressed()
}

class ReceiverTypeViewModel: ReceiverTypeViewModelProtocol {
    
    private var receiverType: RemitterReceiverType? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var receiverTypeItemPickerViewModel: ItemPickerViewModel {
        return ItemPickerViewModel(data: [RemitterReceiverTypePickerItemModel(title: RemitterReceiverType.cnic.getTitle(), key: RemitterReceiverType.cnic.rawValue), RemitterReceiverTypePickerItemModel(title: RemitterReceiverType.bank.getTitle(), key: RemitterReceiverType.bank.rawValue)])
    }
    
    var output: ReceiverTypeViewModelOutput?
    
    private var router: ReceiverTypeRouter
    
    init(router: ReceiverTypeRouter) {
        self.router = router
    }

    enum Output {
        case showError(error: APIResponseError)
        case showAlert(alert: AlertViewModel)
        case showActivityIndicator(show: Bool)
        case setNoteLbl(text: String)
        case buttonState(enabled: Bool)
        case setReceiverType(text: String)
    }
    
    func viewDidLoad() {
        let text = "Note: You can add maximum 5 receivers.".localized
        output?(.setNoteLbl(text: text))
        output?(.buttonState(enabled: false))
    }
    
    func nextButtonPressed() {
        guard let type = receiverType else { return }
        router.navigateToReceiverFormScreen(receiverType: type)
    }

    func didSelect(receiverType: RemitterReceiverTypePickerItemModel) {
        self.receiverType = receiverType.receiverType
        output?(.setReceiverType(text: self.receiverType?.getTitle() ?? ""))
    }
    
    private func validateRequiredFields() {
        if receiverType == nil {
            output?(.buttonState(enabled: false))
        } else {
            output?(.buttonState(enabled: true))
        }
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
    
}

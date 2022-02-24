//
//  ReceiverSuccessViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 21/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias ReceiverSuccessViewModelOutput = (ReceiverSuccessViewModel.Output) -> Void

protocol ReceiverSuccessViewModelProtocol {
    var output: ReceiverSuccessViewModelOutput? { get set }
    
    func viewDidLoad()
    func doneButtonPressed()
}

class ReceiverSuccessViewModel: ReceiverSuccessViewModelProtocol {
    var output: ReceiverSuccessViewModelOutput?
    
    private var router: ReceiverSuccessRouter
    
    init(router: ReceiverSuccessRouter) {
        self.router = router
    }

    enum Output {
        case showError(error: APIResponseError)
        case showAlert(alert: AlertViewModel)
        case showActivityIndicator(show: Bool)
        case setSuccessMessage(text: String)
    }
    
    func viewDidLoad() {
        let text = "Your Remittance\nReceiver XYZ will be\nadded upon\nNADRA\nVerification".localized
        output?(.setSuccessMessage(text: text))
    }
    
    func doneButtonPressed() {
        router.popToHomeScreen()
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
    
}

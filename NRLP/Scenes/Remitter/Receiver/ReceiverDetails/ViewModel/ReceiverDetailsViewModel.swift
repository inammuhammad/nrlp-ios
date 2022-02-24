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
        case showError(error: APIResponseError)
        case showAlert(alert: AlertViewModel)
        case showActivityIndicator(show: Bool)
        case showBankFields(hidden: Bool)
        case setUser(model: ReceiverModel)
    }
    
    func viewDidLoad() {
        // SHOW BANK FIELDS HERE
        if model?.receiverType == .bank {
            output?(.showBankFields(hidden: false))
        } else {
            output?(.showBankFields(hidden: true))
        }
        setUser()
    }
    
    private func setUser(){
        guard let recieverModel = model else { return }
        output?(.setUser(model: recieverModel))
    }
    
    func deleteButtonPressed() {
        // DELETE API HERE
        
        router.popToPreviousScreen()
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
    
}

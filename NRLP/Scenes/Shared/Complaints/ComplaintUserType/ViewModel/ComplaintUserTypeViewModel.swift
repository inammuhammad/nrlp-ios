//
//  ComplaintUserTypeViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 26/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias ComplaintUserTypeViewModelOutput = (ComplaintUserTypeViewModel.Output) -> Void

protocol ComplaintUserTypeViewModelProtocol {
    
    var output: ComplaintUserTypeViewModelOutput? { get set}
    
    var accountType: String? {get set}
    
    var accountTypeItemModel: [RadioButtonItemModel] { get }
    func viewDidLoad()
    func nextButtonPressed()
    
}

class ComplaintUserTypeViewModel: ComplaintUserTypeViewModelProtocol {
    
    private var router: ComplaintUserTypeRouter
    var output: ComplaintUserTypeViewModelOutput?
    
    var accountType: String? {
        didSet {
            checkNextButtonState()
        }
    }
    
    var accountTypeItemModel: [RadioButtonItemModel] = []
    
    enum Output {
        case nextButtonState(state: Bool)
    }
    
    init(router: ComplaintUserTypeRouter) {
        self.router = router
        setupAccountType()
    }
    
    func viewDidLoad() {
        setupAccountType()
    }
    
    private func setupAccountType() {
        accountTypeItemModel = [
            RadioButtonItemModel(title: AccountType.remitter.getTitle(), key: AccountType.remitter.rawValue),
            RadioButtonItemModel(title: AccountType.beneficiary.getTitle(), key: AccountType.beneficiary.rawValue)
        ]
        accountType = accountTypeItemModel.first?.key
    }
    
    private func checkNextButtonState() {
        if accountType != nil {
            output?(.nextButtonState(state: true))
        } else {
            output?(.nextButtonState(state: false))
        }
    }
    
    func nextButtonPressed() {
        if let type = accountType, let accountTypeValue = AccountType(rawValue: type) {
            self.router.navigateToComplaintTypeScreen(userType: accountTypeValue)
        }
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

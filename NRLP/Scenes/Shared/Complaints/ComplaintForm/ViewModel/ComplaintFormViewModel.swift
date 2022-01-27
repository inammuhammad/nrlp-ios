//
//  ComplaintFormViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 26/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

typealias ComplaintFormViewModelOutput = (ComplaintFormViewModel.Output) -> Void

protocol ComplaintFormViewModelProtocol {
    
    var output: ComplaintFormViewModelOutput? { get set}
    var name: String? { get set }
    var cnic: String? { get set }
    var mobileNumber: String? { get set }
    var email: String? { get set }
    
    var complaintTypeItemModel: [RadioButtonItemModel] { get }
    
    func viewDidLoad()
    func nextButtonPressed()
    func countryTextFieldTapped()
    
}

class ComplaintFormViewModel: ComplaintFormViewModelProtocol {
    
    var name: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var cnic: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var mobileNumber: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var email: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var country: Country? {
        didSet {
            validateRequiredFields()
        }
    }
    
    private var router: ComplaintFormRouter
    var output: ComplaintFormViewModelOutput?
    private var userType: AccountType
    private var loginState: UserLoginState
    private var complaintType: ComplaintTypes
    
    var complaintTypeItemModel: [RadioButtonItemModel] = []
    
    enum Output {
        case nextButtonState(state: Bool)
        case showTextFields(loggedInState: UserLoginState, complaintType: ComplaintTypes, userType: AccountType)
        case updateCountry(name: String)
        case updateMobileCode(code: String, length: Int)
        case updateMobilePlaceholder(placeholder: String)
    }
    
    init(router: ComplaintFormRouter, type: AccountType, loginState: UserLoginState, complaintType: ComplaintTypes) {
        self.router = router
        self.userType = type
        self.loginState = loginState
        self.complaintType = complaintType
        setupComplaintType()
    }
    
    func viewDidLoad() {
        setupComplaintType()
        output?(.nextButtonState(state: true))
        output?(.showTextFields(loggedInState: self.loginState, complaintType: self.complaintType, userType: self.userType))
        
    }
    
    private func setupComplaintType() {
        complaintTypeItemModel = [RadioButtonItemModel(title: complaintType.getTitle(), key: complaintType.rawValue)]
    }
    
    func nextButtonPressed() {
        
    }
    
    func countryTextFieldTapped() {
        router.navigateToCountryPicker(with: { [weak self] selectedCountry in
            if self?.country != selectedCountry {
                self?.country = selectedCountry
                self?.output?(.updateCountry(name: selectedCountry.country))
                self?.output?(.updateMobileCode(code: selectedCountry.code + " - ", length: selectedCountry.length))
                self?.output?(.updateMobilePlaceholder(placeholder: Array(repeating: "x".localized, count: selectedCountry.length).joined()))
            }
        }, accountType: self.userType)
    }
    
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
    
    private func validateRequiredFields() {
        if name?.isBlank ?? true || cnic?.isBlank ?? true || country == nil || mobileNumber?.isBlank ?? true {
            output?(.nextButtonState(state: false))
        } else {
            output?(.nextButtonState(state: true))
        }
    }
}

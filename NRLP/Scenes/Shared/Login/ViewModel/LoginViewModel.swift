//
//  LoginViewModel.swift
//  1Link-NRLP
//
//  Created by ajmal on 06/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias LoginViewModelOutput = (LoginViewModel.Output) -> Void

protocol LoginViewModelProtocol {
    
    var output: LoginViewModelOutput? { get set}
    func loginButtonPressed()
    func registerButtonPreessed()
    var cnic: String? { get set }
    var paassword: String? { get set }
    var accountType: String? {get set}
    var accountTypeItemModel: [RadioButtonItemModel] { get }
    func viewDidLoad()
    func viewWillAppear()
    func forgotPasswordPressed()
    func resetData()
    func aboutButtonPressed()
    func benefitsButtonPressed()
    func complaintsButtonPressed()
}

class LoginViewModel: LoginViewModelProtocol {
    
    private var service: APIKeyServiceDecorator<LoginServiceProtocol>
    private var router: LoginRouter
    var output: LoginViewModelOutput?
    
    var paassword: String? {
        didSet {
            checkLoginButtonState()
        }
    }
    var cnic: String? {
        didSet {
            checkLoginButtonState()
        }
    }
    
    var accountType: String? {
        didSet {
            checkLoginButtonState()
        }
    }
    
    var accountTypeItemModel: [RadioButtonItemModel] = []
    
    enum Output {
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case loginButtonState(state: Bool)
        case jailBroken
        case cnicLabelState(error: Bool, errorMsg: String?)
        case passwordLabelState(error: Bool, errorMsg: String?)
    }
    
    init(service: APIKeyServiceDecorator<LoginServiceProtocol>,
         router: LoginRouter) {
        
        self.service = service
        self.router = router
        setupAccountType()
    }
    
    private func setupAccountType() {
        accountTypeItemModel = [
            RadioButtonItemModel(title: AccountType.remitter.getTitle(), key: AccountType.remitter.rawValue),
            RadioButtonItemModel(title: AccountType.beneficiary.getTitle(), key: AccountType.beneficiary.rawValue)
        ]
        accountType = accountTypeItemModel.first?.key
    }
    
    func resetData() {
        
        self.cnic = ""
        self.paassword = ""
        accountType = accountTypeItemModel.first?.key
    }
    
    func registerButtonPreessed() {
        router.navigateToRegistrationScreen()
    }
    
    func viewDidLoad() {
        if UIDevice.current.isJailBroken {
            output?(.jailBroken)
        }
        NRLPUserDefaults.shared.receiverManagemntSkipped(false)
    }
    
    func viewWillAppear() {
        AESConfigs.resetIV()
        AESConfigs.currentConfiguration = .normal
//        AESConfigs.currentConfiguration = .randomKey
    }
    
    func loginButtonPressed() {
        
        let vaild = validateData()
        if vaild {
            let requestModel = getLoginRequestModel()
            output?(.showActivityIndicator(show: true))
            
            if requestModel.cnicNicop == TestConstants.CNIC1.rawValue || requestModel.cnicNicop == TestConstants.CNIC2.rawValue || requestModel.cnicNicop == TestConstants.CNIC3.rawValue {
                let newRequestModel = getLoginRequestModel(isDummyLogin: true)
                service.decoratee.login(requestModel: newRequestModel) { [weak self] (result) in
                    guard let self = self else { return }
                    self.output?(.showActivityIndicator(show: false))
                    switch result {
                    case .success(let response):
                        self.router.navigateToHomeScreen(user: response.user)
                    case .failure(let error):
                        if let underlayingError = error.underlayingErrorCode,
                           underlayingError == ErrorConstants.deviceNotRegistered.rawValue {
                            self.updateUUIDRelogin()
                        } else {
                            self.output?(.showError(error: error))
                        }
                    }
                }
                
                return
            }
            
            service.dispatchForKey(cnic: requestModel.cnicNicop, type: AccountType.fromRaw(raw: requestModel.accountType)) { [weak self] error in
                guard error == nil else {
                    self?.output?(.showActivityIndicator(show: false))
                    self?.output?(.showError(error: error!))
                    return
                }
                guard let self = self else { return }
                self.service.decoratee.login(requestModel: requestModel) {[weak self] (result) in
                    guard let self = self else { return }
                    self.output?(.showActivityIndicator(show: false))
                    switch result {
                    case .success(let response):
                        self.router.navigateToHomeScreen(user: response.user)
                    case .failure(let error):
                        if let underlayingError = error.underlayingErrorCode,
                           underlayingError == ErrorConstants.deviceNotRegistered.rawValue {
                            self.updateUUIDRelogin()
                        } else {
                            self.output?(.showError(error: error))
                        }
                    }
                }
            }
        }
    }
    
    func updateUUIDRelogin() {
        AESConfigs.currentConfiguration = .updateUUID
        output?(.showActivityIndicator(show: true))
        let requestModel = getLoginRequestModel()
        service.decoratee.login(requestModel: requestModel) {[weak self] (result) in
            guard let self = self else { return }
            AESConfigs.currentConfiguration = .normal
            self.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                self.router.navigateToHomeScreen(user: response.user)
            case .failure(let error):
                if let underlayingError = error.underlayingErrorCode,
                   underlayingError == ErrorConstants.deviceNotRegistered.rawValue {
                    AESConfigs.currentConfiguration = .updateUUID
                    self.router.navigateToUUIDChangeScreen(model: self.getLoginRequestModel())
                } else {
                    self.output?(.showError(error: error))
                }
            }
        }
        
    }
    
    func forgotPasswordPressed() {
        
        self.router.navigateToForgotPassword()
    }
    
    private func getLoginRequestModel(isDummyLogin: Bool = false) -> LoginRequestModel {
        
        return LoginRequestModel(accountType: accountType ?? "",
                                 cnicNicop: cnic ?? "", paassword: paassword ?? "", isDummyLogin: isDummyLogin)
    }
    
    func aboutButtonPressed() {
        self.router.navigateToAbout()
    }
    
    func benefitsButtonPressed() {
        self.router.navigateToBenefits()
    }
    
    func complaintsButtonPressed() {
        self.router.navigateToComplaints()
    }
    
    private func checkLoginButtonState() {
        
        if cnic?.count ?? 0 == 13, paassword?.count ?? 0 >= 8, accountType != nil {
            output?(.loginButtonState(state: true))
        } else {
            output?(.loginButtonState(state: false))
        }
        
    }
    
    private func validateData() -> Bool {
        
        var isValid = true
        // cnic label validations
        
        if cnic?.isValid(for: RegexConstants.cnicRegex) ?? false {
            output?(.cnicLabelState(error: false, errorMsg: nil))
        } else {
            output?(.cnicLabelState(error: true, errorMsg: StringConstants.ErrorString.cnicError.localized))
            isValid = false
        }
        
        if paassword?.isValid(for: RegexConstants.loginPaasswordRegex) ?? false {
            output?(.passwordLabelState(error: false, errorMsg: nil))
        } else {
            output?(.passwordLabelState(error: true, errorMsg: StringConstants.ErrorString.paasswordError.localized))
            isValid = false
        }
        
        return isValid
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

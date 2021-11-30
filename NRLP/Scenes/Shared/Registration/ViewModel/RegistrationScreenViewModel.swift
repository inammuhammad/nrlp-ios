//
//  RegistrationScreenViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias RegistrationViewModelOutput = (RegistrationViewModel.Output) -> Void

protocol RegistrationViewModelProtocol {
    var output: RegistrationViewModelOutput? { get set}
    var accountTypePickerViewModel: ItemPickerViewModel { get }
    var passportTypePickerViewModel: ItemPickerViewModel { get }
    var name: String? { get set }
    var cnic: String? { get set }
    var residentID: String? { get set }
    var mobileNumber: String? { get set }
    var email: String? { get set }
    var paassword: String? { get set }
    var rePaassword: String? { get set }
    var passportNumber: String? { get set }

    func nextButtonPressed()
    func countryTextFieldTapped()
    func didSelectPassportType(passportType: PassportTypePickerItemModel?)
    func didSelect(accountType: AccountTypePickerItemModel?)
    func didReEnteredPassword(rePaassword: String)
}

class RegistrationViewModel: RegistrationViewModelProtocol {
    
    enum RegistrationFormInputFieldType {
        case fullName
        case cnic
        case residentID
        case mobile
        case email
        case password
        case rePassword
        case passportNumber
    }
    
    private var router: RegistrationRouter
    var output: RegistrationViewModelOutput?

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
    
    var residentID: String? {
        didSet {
            validateRequiredFields()
        }
    }

    var country: Country? {
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

    var paassword: String? {
        didSet {
            validateRequiredFields()
        }
    }

    var rePaassword: String? {
        didSet {
            validateRequiredFields()
        }
    }

    var accountType: AccountType? {
        didSet {
            updateProgress()
            validateRequiredFields()
        }
    }
    
    var passportType: PassportType? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var passportNumber: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var accountTypePickerViewModel: ItemPickerViewModel {
        return ItemPickerViewModel(data: [AccountTypePickerItemModel(title: AccountType.remitter.getTitle(), key: AccountType.remitter.rawValue), AccountTypePickerItemModel(title: AccountType.beneficiary.getTitle(), key: AccountType.beneficiary.rawValue)])
    }

    var passportTypePickerViewModel: ItemPickerViewModel {
        return ItemPickerViewModel(data: [PassportTypePickerItemModel(title: PassportType.international.getTitle(), key: PassportType.international.rawValue), PassportTypePickerItemModel(title: PassportType.pakistani.getTitle(), key: PassportType.pakistani.rawValue)])
    }
    
    init(router: RegistrationRouter) {
        self.router = router
    }

    func nextButtonPressed() {
        
        let (isValid, topErrorField) = validateDataWithRegex()
        
        if !isValid {
            if let field = topErrorField {
                output?(.focusField(type: field))
            }
            return
        }
        
        let residentIDValue = (residentID?.isEmpty ?? false) ? nil : residentID
        let registerModel = RegisterRequestModel(accountType: accountType!.rawValue, cnicNicop: cnic!, email: email ?? "", fullName: name!, mobileNo: (country?.code ?? "") + (mobileNumber ?? ""), paassword: paassword!, passportType: passportType?.rawValue ?? "", passportNumber: passportNumber ?? "", registrationCode: nil, transactionAmount: residentIDValue, transactionRefNo: "", residentID: residentIDValue, country: country?.country)
        switch accountType {
        case .beneficiary:
            router.navigateToBeneficiaryVerificationScreen(model: registerModel)
        case .remitter:
            router.navigateToRemitterVerificationScreen(model: registerModel)
        case .none:
            break
        }
    }

    private func updateProgress() {
        switch accountType {
        case .beneficiary:
            output?(.updateProgressBar(toProgress: 0.33))
        case .remitter:
            output?(.updateProgressBar(toProgress: 0.25))
        case .none:
            break
        }
    }

    func didSelectPassportType(passportType: PassportTypePickerItemModel?) {
        self.passportType = passportType?.passportType
        output?(.updatePassportType(passportType: self.passportType?.getTitle() ?? ""))
        output?(.showPassportNumberField(isVisible: true))
    }
    
    func didSelect(accountType: AccountTypePickerItemModel?) {
        self.accountType = accountType?.accountType
        if accountType?.accountType == AccountType.remitter {
            output?(.showNewFields(isRemitter: true))
            output?(.showRemitterPopup(viewModel: getAlert()))
        } else {
            output?(.showNewFields(isRemitter: false))
        }
        output?(.updateAccountType(accountType: self.accountType?.getTitle() ?? ""))
    }

    func countryTextFieldTapped() {
        router.navigateToCountryPicker(with: { [weak self] selectedCountry in
            if self?.country != selectedCountry {
                self?.country = selectedCountry
                self?.output?(.updateCountry(name: selectedCountry.country))
                self?.output?(.updateMobileCode(code: selectedCountry.code + " - ", length: selectedCountry.length))
                self?.output?(.updateMobilePlaceholder(placeholder: Array(repeating: "x".localized, count: selectedCountry.length).joined()))
            }
        }, accountType: self.accountType)
    }

    enum Output {
        case showError(error: APIResponseError)
        case updateCountry(name: String)
        case updateMobileCode(code: String, length: Int)
        case updateMobilePlaceholder(placeholder: String)
        case nextButtonState(enableState: Bool)
        case nameTextField(errorState: Bool, error: String?)
        case cnicTextField(errorState: Bool, error: String?)
        case residentTextField(errorState: Bool, error: String?)
        case countryTextField(errorState: Bool, error: String?)
        case mobileNumberTextField(errorState: Bool, error: String?)
        case emailTextField(errorState: Bool, error: String?)
        case passwordTextField(errorState: Bool, error: String?)
        case rePasswordTextField(errorState: Bool, error: String?)
        case passportNumberTextField(errorState: Bool, error: String?)
        case accountTypeTextField(errorState: Bool, error: String?)
        case passportTypeTextField(errorState: Bool, error: String?)
        case updateAccountType(accountType: String)
        case updatePassportType(passportType: String)
        case showPassportNumberField(isVisible: Bool)
        case updateProgressBar(toProgress: Float)
        case focusField(type: RegistrationFormInputFieldType)
        case showNewFields(isRemitter: Bool)
        case showRemitterPopup(viewModel: AlertViewModel)
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

extension RegistrationViewModel {
    private func validateRequiredFields() {
        if name?.isBlank ?? true || cnic?.isBlank ?? true || country == nil || mobileNumber?.isBlank ?? true || paassword?.isBlank ?? true || rePaassword?.isBlank ?? true  || accountType == nil {
            output?(.nextButtonState(enableState: false))
        } else {
            if accountType == .remitter {
                if passportType == nil  || residentID?.isBlank ?? true || passportNumber?.isBlank ?? true {
                    output?(.nextButtonState(enableState: false))
                } else {
                    output?(.nextButtonState(enableState: true))
                }
            } else {
                output?(.nextButtonState(enableState: true))
            }
        }
    }

    func didReEnteredPassword(rePaassword: String) {
        if !rePaassword.isEmpty && rePaassword.isValid(for: RegexConstants.paasswordRegex) && paassword == rePaassword {
            self.rePaassword = rePaassword
            output?(.rePasswordTextField(errorState: false, error: nil))
        } else {
            output?(.rePasswordTextField(errorState: true, error: StringConstants.ErrorString.reEnterPaasswordError.localized))
        }
    }

    private func validateDataWithRegex() -> (Bool, RegistrationFormInputFieldType?) {
        var isValid: Bool = true

        var errorTopField: RegistrationFormInputFieldType?
        
        if name?.isValid(for: RegexConstants.nameRegex) ?? false {
            output?(.nameTextField(errorState: false, error: nil))
        } else {
            output?(.nameTextField(errorState: true, error: StringConstants.ErrorString.nameError.localized))
            isValid = false
            errorTopField = errorTopField ?? .fullName
        }

        if cnic?.isValid(for: RegexConstants.cnicRegex) ?? false {
            output?(.cnicTextField(errorState: false, error: nil))
        } else {
            output?(.cnicTextField(errorState: true, error: StringConstants.ErrorString.cnicError.localized))
            isValid = false
            errorTopField = errorTopField ?? .cnic
        }

        if country != nil {
            output?(.countryTextField(errorState: false, error: nil))
        } else {
            output?(.countryTextField(errorState: true, error: StringConstants.ErrorString.countryError.localized))
            isValid = false
        }

        if country != nil && mobileNumber?.count ?? 0 == country?.length && mobileNumber?.isValid(for: RegexConstants.mobileNumberRegex) ?? false {
            output?(.mobileNumberTextField(errorState: false, error: nil))
        } else {
            output?(.mobileNumberTextField(errorState: true, error: StringConstants.ErrorString.mobileNumberError.localized))
            isValid = false
            errorTopField = errorTopField ?? .mobile
        }

        if email == nil || email?.isEmpty ?? true || email?.isValid(for: RegexConstants.emailRegex) ?? false {
            output?(.emailTextField(errorState: false, error: nil))
        } else {
            output?(.emailTextField(errorState: true, error: StringConstants.ErrorString.emailError.localized))
            isValid = false
            errorTopField = errorTopField ?? .email
        }

        if paassword?.isValid(for: RegexConstants.paasswordRegex) ?? false {
            output?(.passwordTextField(errorState: false, error: nil))
        } else {
            output?(.passwordTextField(errorState: true, error: StringConstants.ErrorString.createPaasswordError.localized))
            isValid = false
            errorTopField = errorTopField ?? .password
        }

//        if rePassword?.isValid(for: RegexConstants.passwordRegex) ?? false && // Changed during Unit Testing
        if paassword == rePaassword {
            output?(.rePasswordTextField(errorState: false, error: nil))
        } else {
            output?(.rePasswordTextField(errorState: true, error: StringConstants.ErrorString.reEnterPaasswordError.localized))
            isValid = false
            errorTopField = errorTopField ?? .rePassword
        }

        if accountType != nil {
            output?(.accountTypeTextField(errorState: false, error: nil))
        } else {
            output?(.accountTypeTextField(errorState: true, error: StringConstants.ErrorString.accountTypeError.localized))
            isValid = false
        }
        
        if accountType == .remitter {
            if passportType != nil {
                output?(.passportTypeTextField(errorState: false, error: nil))
            } else {
                output?(.accountTypeTextField(errorState: true, error: StringConstants.ErrorString.passortTypeError.localized))
                output?(.showPassportNumberField(isVisible: false))
                isValid = false
            }

            if residentID == nil || residentID?.isBlank == true {
                output?(.residentTextField(errorState: true, error: StringConstants.ErrorString.residentIdError))
                isValid = false
            } else {
                output?(.residentTextField(errorState: false, error: nil))
            }
            
            if passportNumber == nil || passportNumber?.isEmpty ?? true || passportNumber?.isValid(for: RegexConstants.passportRegex) ?? false {
                output?(.passportNumberTextField(errorState: false, error: nil))
            } else {
                output?(.passportNumberTextField(errorState: true, error: StringConstants.ErrorString.passportNumberError.localized))
                isValid = false
                errorTopField = errorTopField ?? .passportNumber
            }
        }
                
        return (isValid, errorTopField)
    }
    
    private func getRemitterAlertDescription() -> NSAttributedString {

        let regularAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .smallFontSize)]

        let attributePart1 = NSMutableAttributedString(string: "For further assistance, you may contact +92-21-111-116757".localized, attributes: regularAttributes)
        
        let alertDesctiption = NSMutableAttributedString()
        alertDesctiption.append(attributePart1)
        
        return alertDesctiption
    }
    
    private func getAlert() -> AlertViewModel {
        let alert: AlertViewModel

        let okButton = AlertActionButtonModel(buttonTitle: "OK".localized, buttonAction: nil)

        alert = AlertViewModel(alertHeadingImage: .remitterInfo, alertTitle: "Dear Remitter,\nPlease wait at least 05\nworking days after your\nremittance has been\nproceed to register for\n Sohni Dharti.".localized, alertDescription: nil, alertAttributedDescription: getRemitterAlertDescription(), primaryButton: okButton)
        return alert
    }
}

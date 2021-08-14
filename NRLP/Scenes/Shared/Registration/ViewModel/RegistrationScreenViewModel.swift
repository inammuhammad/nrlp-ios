//
//  RegistrationScreenViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias RegistrationViewModelOutput = (RegistrationViewModel.Output) -> Void

protocol RegistrationViewModelProtocol {
    var output: RegistrationViewModelOutput? { get set}
    var accountTypePickerViewModel: ItemPickerViewModel { get }
    var name: String? { get set }
    var cnic: String? { get set }
    var mobileNumber: String? { get set }
    var email: String? { get set }
    var paassword: String? { get set }
    var rePaassword: String? { get set }

    func nextButtonPressed()
    func countryTextFieldTapped()
    func didSelect(accountType: AccountTypePickerItemModel?)
    func didReEnteredPassword(rePaassword: String)
}

class RegistrationViewModel: RegistrationViewModelProtocol {

    enum RegistrationFormInputFieldType {
        case fullName
        case cnic
        case mobile
        case email
        case password
        case rePassword
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

    var accountTypePickerViewModel: ItemPickerViewModel {
        return ItemPickerViewModel(data: [AccountTypePickerItemModel(title: AccountType.remitter.getTitle(), key: AccountType.remitter.rawValue), AccountTypePickerItemModel(title: AccountType.beneficiary.getTitle(), key: AccountType.beneficiary.rawValue)])
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
        let registerModel = RegisterRequestModel(accountType: accountType!.rawValue, cnicNicop: cnic!, email: email ?? "", fullName: name!, mobileNo: (country?.code ?? "") + (mobileNumber ?? ""), paassword: paassword!, registrationCode: nil, transactionAmount: nil, transactionRefNo: nil)
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

    func didSelect(accountType: AccountTypePickerItemModel?) {
        self.accountType = accountType?.accountType
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
        })
    }

    enum Output {
        case showError(error: APIResponseError)
        case updateCountry(name: String)
        case updateMobileCode(code: String, length: Int)
        case updateMobilePlaceholder(placeholder: String)
        case nextButtonState(enableState: Bool)
        case nameTextField(errorState: Bool, error: String?)
        case cnicTextField(errorState: Bool, error: String?)
        case countryTextField(errorState: Bool, error: String?)
        case mobileNumberTextField(errorState: Bool, error: String?)
        case emailTextField(errorState: Bool, error: String?)
        case passwordTextField(errorState: Bool, error: String?)
        case rePasswordTextField(errorState: Bool, error: String?)
        case accountTypeTextField(errorState: Bool, error: String?)
        case updateAccountType(accountType: String)
        case updateProgressBar(toProgress: Float)
        case focusField(type: RegistrationFormInputFieldType)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

extension RegistrationViewModel {
    private func validateRequiredFields() {
        if name?.isBlank ?? true || cnic?.isBlank ?? true || country == nil || mobileNumber?.isBlank ?? true || paassword?.isBlank ?? true || rePaassword?.isBlank ?? true || accountType == nil {
            output?(.nextButtonState(enableState: false))
        } else {
            output?(.nextButtonState(enableState: true))
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

        return (isValid, errorTopField)
    }
}

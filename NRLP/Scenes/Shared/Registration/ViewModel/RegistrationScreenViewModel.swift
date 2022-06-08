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
    var datePickerViewModel: CustomDatePickerViewModel { get }
    var name: String? { get set }
    var fatherName: String? { get set }
    var cnic: String? { get set }
    var birthPlace: String? { get set }
    var cnicIssueDate: Date? { get set }
    var motherMaidenName: String? { get set }
    var residentID: String? { get set }
    var mobileNumber: String? { get set }
    var email: String? { get set }
    var paassword: String? { get set }
    var rePaassword: String? { get set }
    var passportNumber: String? { get set }
    var beneficaryOTP: String? { get set }

    func nextButtonPressed()
    func countryTextFieldTapped()
    func birthPlaceTextFieldTapped()
    func didSelectPassportType(passportType: PassportTypePickerItemModel?)
    func didSelect(accountType: AccountTypePickerItemModel?)
    func didReEnteredPassword(rePaassword: String)
}

class RegistrationViewModel: RegistrationViewModelProtocol {
    
    enum RegistrationFormInputFieldType {
        case userType
        case fullName
        case motherName
        case fatherName
        case birthPlace
        case countryOfResidence
        case cnic
        case cnicIssueDate
        case passportType
        case passportNumber
        case residentID
        case mobileNumber
        case emailAddress
        case password
        case confirmPassword
        case beneficiaryOtp
    }
    
    private var router: RegistrationRouter
    var output: RegistrationViewModelOutput?
    private var service: RegisterUserService
    private var appKeyService: APIKeyServiceDecorator<RegisterUserServiceProtocol>

    var name: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var fatherName: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var motherMaidenName: String? {
        didSet {
            validateRequiredFields()
        }
    }

    var cnic: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var cnicIssueDate: Date? {
        didSet {
            validateRequiredFields()
            self.output?(.updateCnicIssueDate(dateStr: cnicIssueDateString))
        }
    }
    
    var datePickerViewModel: CustomDatePickerViewModel {
        return CustomDatePickerViewModel(maxDate: Date())
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
    
    var birthPlace: String? {
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
    
    var beneficaryOTP: String? {
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
    
    private var cnicIssueDateString: String {
        return DateFormat().formatDateString(to: cnicIssueDate ?? Date(), formatter: .shortDateFormat) ?? "-"
    }
    
    init(router: RegistrationRouter) {
        self.router = router
        self.service = RegisterUserService()
        self.appKeyService = APIKeyServiceDecorator(decoratee: service, appKeyService: AppKeyService())

    }

    func nextButtonPressed() {
        var tuple: (Bool, RegistrationFormInputFieldType?) = (false, nil)
        if self.accountType == .remitter {
            tuple = validateDataWithRegex()
        } else {
            tuple = validateBeneficiaryDataWithRegex()
        }
        
        if !tuple.0 {
            if let field = tuple.1 {
                output?(.focusField(type: field))
            }
            return
        }
        let finalMobile = (country?.code ?? "") + (mobileNumber ?? "-")
        var registerModel = RegisterRequestModel(accountType: accountType?.rawValue ?? "-", cnicNicop: cnic ?? "-", email: email ?? "-", fullName: name ?? "-", mobileNo: finalMobile, paassword: paassword ?? "-", passportType: passportType?.rawValue ?? "-", passportNumber: passportNumber ?? "-", registrationCode: "-", residentID: residentID ?? "-", country: country?.country ?? "-", cnicIssueDate: cnicIssueDateString, motherMaidenName: motherMaidenName ?? "-", birthPlace: birthPlace, sotp: "1", versionNo: "-", tncId: 0)
        switch accountType {
        case .beneficiary:
            registerModel.registrationCode = beneficaryOTP
            self.output?(.showActivityIndicator(show: true))
            appKeyService.dispatchForKey(cnic: registerModel.cnicNicop, type: .beneficiary) { (error) in
                if let error = error {
                    self.output?(.showActivityIndicator(show: false))
                    self.output?(.showError(error: error))
                } else {
                    self.service.registerUser(with: registerModel) { (result) in
                        self.output?(.showActivityIndicator(show: false))
                        switch result {
                        case .success:
                            self.router.navigateToBeneficiaryFormScreen(model: registerModel)
                        case .failure(let error):
                            self.output?(.showError(error: error))
                        }
                    }
                }
            }
//            router.navigateToBeneficiaryFormScreen(model: registerModel)
        case .remitter:
            registerModel.fatherName = fatherName
            
            self.output?(.showActivityIndicator(show: true))
            appKeyService.dispatchForKey(cnic: registerModel.cnicNicop, type: .remitter, configType: .randomKey) { (error) in
                if let error = error {
                    self.output?(.showActivityIndicator(show: false))
                    self.output?(.showError(error: error))
                } else {
                    self.service.registerUser(with: registerModel, completion: { (result) in
                        self.output?(.showActivityIndicator(show: false))
                        switch result {
                        case .success:
                            self.router.navigateToOTPScreen(model: registerModel)
                        case .failure(let error):
                            self.output?(.showError(error: error))
                        }
                    })
                }
            }
        case .none:
            break
        }
    }

    private func updateProgress() {
        switch accountType {
        case .beneficiary:
            output?(.updateProgressBar(toProgress: 0.2))
        case .remitter:
            output?(.updateProgressBar(toProgress: 0.25))
        case .none:
            break
        }
    }

    func didSelectPassportType(passportType: PassportTypePickerItemModel?) {
        self.passportType = passportType?.passportType
        output?(.updatePassportType(passportType: self.passportType?.getTitle() ?? ""))
        // output?(.showPassportNumberField(isVisible: true))
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
        }, accountType: accountType)
    }
    
    func birthPlaceTextFieldTapped() {
        router.navigateToCityPicker { [weak self] selectedCity in
            self?.birthPlace = selectedCity
            self?.output?(.updateBirthPlace(name: selectedCity))
        }
    }

    enum Output {
        case showError(error: APIResponseError)
        case updateCountry(name: String)
        case updateBirthPlace(name: String)
        case updateMobileCode(code: String, length: Int)
        case updateMobilePlaceholder(placeholder: String)
        case nextButtonState(enableState: Bool)
        case textField(errorState: Bool, error: String?, textfieldType: RegistrationFormInputFieldType)
        case updateAccountType(accountType: String)
        case updatePassportType(passportType: String)
        // case showPassportNumberField(isVisible: Bool)
        case updateProgressBar(toProgress: Float)
        case focusField(type: RegistrationFormInputFieldType)
        case showNewFields(isRemitter: Bool)
        case showRemitterPopup(viewModel: AlertViewModel)
        case updateCnicIssueDate(dateStr: String)
        case showActivityIndicator(show: Bool)
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

extension RegistrationViewModel {
    private func validateRequiredFields() {
        if self.accountType == .remitter {
            if name?.isBlank ?? true || fatherName?.isBlank ?? true || country == nil || cnic?.isBlank ?? true || cnicIssueDate == nil || passportType == nil || passportNumber?.isBlank ?? true || residentID?.isBlank ?? true || mobileNumber?.isBlank ?? true || paassword?.isBlank ?? true || rePaassword?.isBlank ?? true || !(birthPlace?.isValid(for: RegexConstants.nameRegex) ?? false) {
                output?(.nextButtonState(enableState: false))
            } else {
                output?(.nextButtonState(enableState: true))
            }
        } else {
            if cnic?.isBlank ?? true || beneficaryOTP?.isBlank ?? true {
                output?(.nextButtonState(enableState: false))
            } else {
                if beneficaryOTP?.trim().count != 4 || cnic?.count ?? 0 < 13 {
                    output?(.nextButtonState(enableState: false))
                } else {
                    output?(.nextButtonState(enableState: true))
                }
            }
        }
    }

    func didReEnteredPassword(rePaassword: String) {
        if !rePaassword.isEmpty && rePaassword.isValid(for: RegexConstants.paasswordRegex) && paassword == rePaassword {
            self.rePaassword = rePaassword
            output?(.textField(errorState: false, error: nil, textfieldType: .confirmPassword))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.reEnterPaasswordError.localized, textfieldType: .confirmPassword))
        }
    }

    private func validateDataWithRegex() -> (Bool, RegistrationFormInputFieldType?) {
        var isValid: Bool = true

        var errorTopField: RegistrationFormInputFieldType?
        
        if name?.isValid(for: RegexConstants.nameRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .fullName))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.fullNameError.localized, textfieldType: .fullName))
            isValid = false
            errorTopField = errorTopField ?? .fullName
        }

        if motherMaidenName?.isValid(for: RegexConstants.nameRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .motherName))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.fullNameError.localized, textfieldType: .motherName))
            isValid = false
            errorTopField = errorTopField ?? .motherName
        }
        
        if fatherName?.count ?? 0 >= 3, fatherName?.isValid(for: RegexConstants.nameRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .fatherName))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.fullNameError.localized, textfieldType: .fatherName))
            isValid = false
            errorTopField = errorTopField ?? .fatherName
        }
        
        if cnic?.isValid(for: RegexConstants.cnicRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .cnic))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.cnicError.localized, textfieldType: .cnic))
            isValid = false
            errorTopField = errorTopField ?? .cnic
        }
        
        if let cnicIssueDate = cnicIssueDate, cnicIssueDate < Date() {
            output?(.textField(errorState: false, error: nil, textfieldType: .cnicIssueDate))
        } else {
            output?(.textField(errorState: true, error: "Please enter a valid CNIC/NICOP Issue Date", textfieldType: .cnicIssueDate))
        }
        
        if birthPlace != nil {
            output?(.textField(errorState: false, error: nil, textfieldType: .birthPlace))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.countryError.localized, textfieldType: .birthPlace))
            isValid = false
        }

        if country != nil {
            output?(.textField(errorState: false, error: nil, textfieldType: .countryOfResidence))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.countryError.localized, textfieldType: .countryOfResidence))
            isValid = false
        }

        if country != nil && mobileNumber?.isValid(for: RegexConstants.mobileNumberRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .mobileNumber))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.mobileNumberError.localized, textfieldType: .mobileNumber))
            isValid = false
            errorTopField = errorTopField ?? .mobileNumber
        }

        if email == nil || email?.isEmpty ?? true || email?.isValid(for: RegexConstants.emailRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .emailAddress))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.emailError.localized, textfieldType: .emailAddress))
            isValid = false
            errorTopField = errorTopField ?? .emailAddress
        }

        if paassword?.isValid(for: RegexConstants.paasswordRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .password))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.createPaasswordError.localized, textfieldType: .password))
            isValid = false
            errorTopField = errorTopField ?? .password
        }

//        if rePassword?.isValid(for: RegexConstants.passwordRegex) ?? false && // Changed during Unit Testing
        if paassword == rePaassword {
            output?(.textField(errorState: false, error: nil, textfieldType: .confirmPassword))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.reEnterPaasswordError.localized, textfieldType: .confirmPassword))
            isValid = false
            errorTopField = errorTopField ?? .confirmPassword
        }

        if accountType != nil {
            output?(.textField(errorState: false, error: nil, textfieldType: .userType))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.accountTypeError.localized, textfieldType: .userType))
            isValid = false
        }
        
        if accountType == .remitter {
            if passportType != nil {
                output?(.textField(errorState: false, error: nil, textfieldType: .passportType))
            } else {
                output?(.textField(errorState: true, error: StringConstants.ErrorString.passortTypeError.localized, textfieldType: .passportType))
                // output?(.showPassportNumberField(isVisible: false))
                isValid = false
            }

            if residentID == nil || residentID?.isBlank == true {
                output?(.textField(errorState: true, error: StringConstants.ErrorString.residentIdError, textfieldType: .residentID))
                isValid = false
            } else {
                output?(.textField(errorState: false, error: nil, textfieldType: .residentID))
            }
            
            if passportNumber == nil || passportNumber?.isEmpty ?? true || passportNumber?.isValid(for: RegexConstants.passportRegex) ?? false {
                output?(.textField(errorState: false, error: nil, textfieldType: .passportNumber))
            } else {
                output?(.textField(errorState: true, error: StringConstants.ErrorString.passportNumberError.localized, textfieldType: .passportNumber))
                isValid = false
                errorTopField = errorTopField ?? .passportNumber
            }
        }
                
        return (isValid, errorTopField)
    }
    
    private func validateBeneficiaryDataWithRegex() -> (Bool, RegistrationFormInputFieldType?) {
        var isValid: Bool = true

        var errorTopField: RegistrationFormInputFieldType?
        
        if cnic?.isValid(for: RegexConstants.cnicRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .cnic))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.cnicError.localized, textfieldType: .cnic))
            isValid = false
            errorTopField = errorTopField ?? .cnic
        }
        
        if beneficaryOTP?.count == 4 {
            output?(.textField(errorState: false, error: nil, textfieldType: .beneficiaryOtp))
        } else {
            output?(.textField(errorState: true, error: "Please enter 4 digit OTP received in SMS", textfieldType: .beneficiaryOtp))
            isValid = false
            errorTopField = errorTopField ?? .beneficiaryOtp
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

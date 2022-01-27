//
//  BeneficiaryFormViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 23/12/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias BeneficiaryFormViewModelOutput = (BeneficiaryFormViewModel.Output) -> Void

protocol BeneficiaryFormViewModelProtocol {
    var output: BeneficiaryFormViewModelOutput? { get set }
    
    var name: String? { get set }
    var motherMaidenName: String? { get set }
    var birthPlace: String? { get set }
    var country: Country? { get set }
    var cnicIssueDate: Date? { get set }
    var mobileNumber: String? { get set }
    var emailAddress: String? { get set }
    var password: String? { get set }
    var confirmPassword: String? { get set }
    
    var datePickerViewModel: CustomDatePickerViewModel { get }
    
    func nextButtonPressed()
    func countryTextFieldTapped()
    func birthPlaceTextFieldTapped()
    func didReEnteredPassword(rePaassword: String)
}

class BeneficiaryFormViewModel: BeneficiaryFormViewModelProtocol {
    
    enum BeneficiaryFormInputFieldType {
        case fullName
        case motherName
        case birthPlace
        case countryOfResidence
        case cnicIssueDate
        case mobileNumber
        case emailAddress
        case password
        case confirmPassword
    }
    
    var name: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var motherMaidenName: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var birthPlace: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var country: Country? {
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
    
    var mobileNumber: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var emailAddress: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var password: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var confirmPassword: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var datePickerViewModel: CustomDatePickerViewModel {
        return CustomDatePickerViewModel(maxDate: Date())
    }
    
    private var cnicIssueDateString: String {
        return DateFormat().formatDateString(to: cnicIssueDate ?? Date(), formatter: .shortDateFormat) ?? ""
    }
    
    var model: RegisterRequestModel?
    private var router: BeneficiaryFormRouter
    var output: BeneficiaryFormViewModelOutput?
    
    enum Output {
        case showError(error: APIResponseError)
        case updateCountry(name: String)
        case updateBirthPlace(name: String)
        case updateMobileCode(code: String, length: Int)
        case updateMobilePlaceholder(placeholder: String)
        case nextButtonState(enableState: Bool)
        case textField(errorState: Bool, error: String?, textfieldType: BeneficiaryFormInputFieldType)
        case updateProgressBar(toProgress: Float)
        case focusField(type: BeneficiaryFormInputFieldType)
        case updateCnicIssueDate(dateStr: String)
    }
    
    init(model: RegisterRequestModel, router: BeneficiaryFormRouter) {
        self.model = model
        self.router = router
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

extension BeneficiaryFormViewModel {
    func didReEnteredPassword(rePaassword: String) {
        if !rePaassword.isEmpty && rePaassword.isValid(for: RegexConstants.paasswordRegex) && password == rePaassword {
            self.confirmPassword = rePaassword
            output?(.textField(errorState: false, error: nil, textfieldType: .confirmPassword))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.reEnterPaasswordError.localized, textfieldType: .confirmPassword))
        }
    }
    
    func nextButtonPressed() {
        let (isValid, topField) = validateDataWithRegex()
        if !isValid {
            if let field = topField {
                output?(.focusField(type: field))
            }
            return
        }
        setModelValues()
        if let registerModel = model {
            self.router.navigateToTermsAndConditionScreen(registerModel: registerModel)
        }
    }
    
    private func setModelValues() {
        self.model?.birthPlace = birthPlace
        self.model?.country = country?.country
        self.model?.motherMaidenName = "-"
        self.model?.cnicIssueDate = self.cnicIssueDateString
        self.model?.email = self.emailAddress ?? ""
        self.model?.passportType = "-"
        self.model?.passportNumber = "-"
        self.model?.residentID = "-"
        self.model?.fullName = self.name ?? ""
        self.model?.mobileNo = self.mobileNumber ?? ""
        self.model?.sotp = "2"
        self.model?.paassword = self.password ?? ""
        self.model?.motherMaidenName = self.motherMaidenName ?? ""
    }
    
    func countryTextFieldTapped() {
        router.navigateToCountryPicker(with: { [weak self] selectedCountry in
            if self?.country != selectedCountry {
                self?.country = selectedCountry
                self?.output?(.updateCountry(name: selectedCountry.country))
                self?.output?(.updateMobileCode(code: selectedCountry.code + " - ", length: selectedCountry.length))
                self?.output?(.updateMobilePlaceholder(placeholder: Array(repeating: "x".localized, count: selectedCountry.length).joined()))
            }
        }, accountType: AccountType(rawValue: model?.accountType ?? ""))
    }
    
    func birthPlaceTextFieldTapped() {
        router.navigateToCityPicker { [weak self] selectedCity in
            self?.birthPlace = selectedCity
            self?.output?(.updateBirthPlace(name: selectedCity))
        }
    }
    
    private func validateRequiredFields() {
        if name?.isBlank ?? true || motherMaidenName?.isBlank ?? true || cnicIssueDateString.isBlank || country == nil || mobileNumber?.isBlank ?? true || password?.isBlank ?? true || confirmPassword?.isBlank ?? true  || birthPlace == nil {
            output?(.nextButtonState(enableState: false))
        } else {
            output?(.nextButtonState(enableState: true))
        }
    }
    
    private func validateDataWithRegex() -> (Bool, BeneficiaryFormInputFieldType?) {
        var isValid: Bool = true

        var errorTopField: BeneficiaryFormInputFieldType?
        
        if name?.isValid(for: RegexConstants.nameRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .fullName))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.nameError.localized, textfieldType: .fullName))
            isValid = false
            errorTopField = errorTopField ?? .fullName
        }
        
        if motherMaidenName?.isValid(for: RegexConstants.nameRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .motherName))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.nameError.localized, textfieldType: .motherName))
            isValid = false
            errorTopField = errorTopField ?? .motherName
        }
        
        if let cnicIssueDate = cnicIssueDate, cnicIssueDate < Date() {
            output?(.textField(errorState: false, error: nil, textfieldType: .cnicIssueDate))
        } else {
            output?(.textField(errorState: true, error: "Please enter a valid CNIC/NICOP Issue Date".localized, textfieldType: .cnicIssueDate))
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

        if emailAddress == nil || emailAddress?.isEmpty ?? true || emailAddress?.isValid(for: RegexConstants.emailRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .emailAddress))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.emailError.localized, textfieldType: .emailAddress))
            isValid = false
            errorTopField = errorTopField ?? .emailAddress
        }

        if password?.isValid(for: RegexConstants.paasswordRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .password))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.createPaasswordError.localized, textfieldType: .password))
            isValid = false
            errorTopField = errorTopField ?? .password
        }

//        if rePassword?.isValid(for: RegexConstants.passwordRegex) ?? false && // Changed during Unit Testing
        if password == confirmPassword {
            output?(.textField(errorState: false, error: nil, textfieldType: .confirmPassword))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.reEnterPaasswordError.localized, textfieldType: .confirmPassword))
            isValid = false
            errorTopField = errorTopField ?? .confirmPassword
        }
                
        return (isValid, errorTopField)
    }
}

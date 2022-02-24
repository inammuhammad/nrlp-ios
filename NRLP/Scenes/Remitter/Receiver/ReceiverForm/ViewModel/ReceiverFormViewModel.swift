//
//  ReceiverFormViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 21/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias ReceiverFormViewModelOutput = (ReceiverFormViewModel.Output) -> Void

protocol ReceiverFormViewModelProtocol {
    var output: ReceiverFormViewModelOutput? { get set }
    
    var datePickerViewModel: CustomDatePickerViewModel { get }
    var name: String? { get set }
    var cnic: String? { get set }
    var cnicIssueDate: Date? { get set }
    var motherMaidenName: String? { get set }
    var mobileNumber: String? { get set }
    var bankName: String? { get set }
    var bankNumber: String? { get set }
    
    func viewDidLoad()
    func countryTextFieldTapped()
    func birthPlaceTextFieldTapped()
    func nextButtonPressed()
}

class ReceiverFormViewModel: ReceiverFormViewModelProtocol {
    
    private var receiverType: RemitterReceiverType
    
    var output: ReceiverFormViewModelOutput?
    
    private var router: ReceiverFormRouter
    
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
    
    var bankName: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var bankNumber: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    private var cnicIssueDateString: String {
        return DateFormat().formatDateString(to: cnicIssueDate ?? Date(), formatter: .shortDateFormat) ?? "-"
    }
    
    init(router: ReceiverFormRouter, receiverType: RemitterReceiverType) {
        self.router = router
        self.receiverType = receiverType
    }
    
    enum ReceiverFormInputFieldType {
        case fullName
        case motherName
        case birthPlace
        case cnic
        case cnicIssueDate
        case countryOfResidence
        case mobileNumber
        case bankName
        case bankNumber
    }

    enum Output {
        case showError(error: APIResponseError)
        case showAlert(alert: AlertViewModel)
        case showActivityIndicator(show: Bool)
        case buttonState(enabled: Bool)
        case updateCnicIssueDate(dateStr: String)
        case updateCountry(name: String)
        case updateBirthPlace(name: String)
        case updateMobileCode(code: String, length: Int)
        case updateMobilePlaceholder(placeholder: String)
        case showBankFields(hidden: Bool)
        case textField(errorState: Bool, error: String?, textfieldType: ReceiverFormInputFieldType)
        case focusField(textField: ReceiverFormInputFieldType)
    }
    
    func viewDidLoad() {
        output?(.showBankFields(hidden: true))
        if receiverType == .bank {
            output?(.showBankFields(hidden: false))
        }
        output?(.buttonState(enabled: false))
    }
    
    func countryTextFieldTapped() {
        router.navigateToCountryPicker(with: { [weak self] selectedCountry in
            if self?.country != selectedCountry {
                self?.country = selectedCountry
                self?.output?(.updateCountry(name: selectedCountry.country))
                self?.output?(.updateMobileCode(code: selectedCountry.code + " - ", length: selectedCountry.length))
                self?.output?(.updateMobilePlaceholder(placeholder: Array(repeating: "x".localized, count: selectedCountry.length).joined()))
            }
        }, accountType: AccountType.beneficiary)
    }
    
    func birthPlaceTextFieldTapped() {
        router.navigateToCityPicker { [weak self] selectedCity in
            self?.birthPlace = selectedCity
            self?.output?(.updateBirthPlace(name: selectedCity))
        }
    }
    
    func nextButtonPressed() {
        if !(validateDataWithRegex().0) {
            output?(.focusField(textField: validateDataWithRegex().1 ?? .fullName))
            return
        }
        
        router.navigateToSuccessScreen()
    }

    private func validateRequiredFields() {
        if name?.isBlank ?? true || cnic?.isBlank ?? true  || cnicIssueDateString.isBlank || motherMaidenName?.isBlank ?? true || birthPlace?.isBlank ?? true || mobileNumber?.isBlank ?? true {
            output?(.buttonState(enabled: false))
        } else {
            if receiverType == .bank {
                if bankName?.isBlank ?? true || bankNumber?.isBlank ?? true {
                    output?(.buttonState(enabled: false))
                } else {
                    output?(.buttonState(enabled: true))
                }
            } else {
                output?(.buttonState(enabled: true))
            }
        }
    }
    
    private func validateDataWithRegex() -> (Bool, ReceiverFormInputFieldType?) {
        var isValid: Bool = true

        var errorTopField: ReceiverFormInputFieldType?
        
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
            output?(.textField(errorState: true, error: "Please enter a valid CNIC/NICOP Issue Date".localized, textfieldType: .cnicIssueDate))
        }
        
        if birthPlace != nil {
            output?(.textField(errorState: false, error: nil, textfieldType: .birthPlace))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.cityError.localized, textfieldType: .birthPlace))
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
        
        if receiverType == .bank {
            if bankName != nil {
                output?(.textField(errorState: false, error: nil, textfieldType: .bankName))
            } else {
                output?(.textField(errorState: true, error: StringConstants.ErrorString.genericEmptyFieldError.localized, textfieldType: .bankName))
                isValid = false
            }
            
            if bankNumber != nil {
                output?(.textField(errorState: false, error: nil, textfieldType: .bankNumber))
            } else {
                output?(.textField(errorState: true, error: StringConstants.ErrorString.genericEmptyFieldError.localized, textfieldType: .bankNumber))
                isValid = false
            }
        }
        
        return (isValid, errorTopField)
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
    
}

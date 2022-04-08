//
//  NadraVerificationFormViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 03/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

typealias NadraVerificationFormViewModelOutput = (NadraVerificationFormViewModel.Output) -> Void

protocol NadraVerificationFormViewModelProtocol {
    var fullName: String? { get set }
    var birthPlace: String? { get set }
    var cnicIssueDate: Date? { get set }
    var motherMaidenName: String? { get set }
    var datePickerViewModel: CustomDatePickerViewModel { get }
    var output: NadraVerificationFormViewModelOutput? { get set }
    
    func birthPlaceTextFieldTapped()
    func verifyButtonPressed()
}

class NadraVerificationFormViewModel: NadraVerificationFormViewModelProtocol {
    
    private var router: NadraVerificationFormRouter
    var output: NadraVerificationFormViewModelOutput?
    private var service: NadraVerificationServiceProtocol?
    private var userModel: UserModel
    
    var fullName: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var birthPlace: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var motherMaidenName: String? {
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
    
    private var cnicIssueDateString: String {
        return DateFormat().formatDateString(to: cnicIssueDate ?? Date(), formatter: .shortDateFormat) ?? "-"
    }
    
    enum Output {
        case updateCnicIssueDate(dateStr: String)
        case updateBirthPlace(name: String)
        case nextButtonState(enableState: Bool)
        case textField(errorState: Bool, error: String?, textfieldType: NadraVerificationTextfieldTypes)
        case focusField(type: NadraVerificationTextfieldTypes)
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
    }
    
    private func validateRequiredFields() {
        if fullName?.isEmpty ?? false || motherMaidenName?.isEmpty ?? false || cnicIssueDateString.isEmpty || birthPlace == nil {
            output?(.nextButtonState(enableState: false))
        } else {
            output?(.nextButtonState(enableState: true))
        }
    }
    
    init(router: NadraVerificationFormRouter, service: NadraVerificationServiceProtocol = NadraVerificationService(), userModel: UserModel) {
        self.router = router
        self.service = service
        self.userModel = userModel
    }
    
    func birthPlaceTextFieldTapped() {
        router.navigateToCityPicker { [weak self] selectedCity in
            self?.birthPlace = selectedCity
            self?.output?(.updateBirthPlace(name: selectedCity))
        }
    }
    
    func verifyButtonPressed() {
        let (isValid, topErrorField) = validateDataWithRegex()
        
        if !isValid {
            if let field = topErrorField {
                output?(.focusField(type: field))
            }
            return
        }
        
        let requestModel = NadraVerificationRequestModel(motherMaidenName: motherMaidenName, fullName: fullName, cnicIssueDate: cnicIssueDateString, birthPlace: birthPlace)
        output?(.showActivityIndicator(show: true))
        service?.verifyUser(requestModel: requestModel, completion: { [self] (result) in
            self.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                userModel.fullName = fullName ?? ""
                userModel.motherMaidenName = motherMaidenName ?? ""
                userModel.birthPlace = birthPlace
                userModel.cnicIssueDateStr = cnicIssueDateString
                self.router.navigateToVerificationCompletionScreen(userModel: self.userModel)
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        })
    }
    
    private func validateDataWithRegex() -> (Bool, NadraVerificationTextfieldTypes?) {
        var isValid: Bool = true

        var errorTopField: NadraVerificationTextfieldTypes?
        
        if fullName?.isValid(for: RegexConstants.nameRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .fullName))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.nameError.localized, textfieldType: .fullName))
            isValid = false
            errorTopField = errorTopField ?? .fullName
        }

        if motherMaidenName?.isValid(for: RegexConstants.nameRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .motherMaidenName))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.nameError.localized, textfieldType: .motherMaidenName))
            isValid = false
            errorTopField = errorTopField ?? .motherMaidenName
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
        
        return (isValid, errorTopField)
    }
    
    enum NadraVerificationTextfieldTypes {
        case fullName
        case motherMaidenName
        case cnicIssueDate
        case birthPlace
    }
}

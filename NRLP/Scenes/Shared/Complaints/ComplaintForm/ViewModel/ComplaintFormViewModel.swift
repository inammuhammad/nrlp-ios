//
//  ComplaintFormViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 26/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

typealias ComplaintFormViewModelOutput = (ComplaintFormViewModel.Output) -> Void

// MARK: Protocol

protocol ComplaintFormViewModelProtocol {
    
    var output: ComplaintFormViewModelOutput? { get set}
    var name: String? { get set }
    var cnic: String? { get set }
    var mobileNumber: String? { get set }
    var mobileOperator: String? { get set }
    var email: String? { get set }
    var specifyDetails: String? { get set }
    var partner: String? { get set }
    
    var partnerPickerViewModel: ItemPickerViewModel { get }
    
    var complaintTypeItemModel: [RadioButtonItemModel] { get }
    
    func viewDidLoad()
    func nextButtonPressed()
    func countryTextFieldTapped()
    func didSelectPartner(partner: RedemptionPartnerPickerItemModel?)
}

class ComplaintFormViewModel: ComplaintFormViewModelProtocol {
    
    // MARK: Protocol - Properties
    
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
    
    var mobileOperator: String? {
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
    
    var specifyDetails: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var partner: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var partnerPickerViewModel: ItemPickerViewModel {
        if complaintType == .redemptionIssues {
            var dataArray: [PickerItemModel] = []
            for partner in partners {
                dataArray.append(RedemptionPartnerPickerItemModel(title: partner.partnerName, key: "\(partner.id)"))
            }
            return ItemPickerViewModel(data: dataArray)
        }
        return ItemPickerViewModel(data: [])
    }
    
    // MARK: Generic Properties
    
    private var router: ComplaintFormRouter
    var output: ComplaintFormViewModelOutput?
    private var userType: AccountType
    private var loginState: UserLoginState
    private var complaintType: ComplaintTypes
    
    private var redemptionService: RedeemService = RedeemService()
    private var partners: [Partner] = []
    
    private var service = ComplaintService()
    
    var complaintTypeItemModel: [RadioButtonItemModel] = []
    
    // MARK: Output
    
    enum Output {
        case showRedemptionPartners
        case showActivityIndicator(show: Bool)
        case nextButtonState(state: Bool)
        case showTextFields(loggedInState: UserLoginState, complaintType: ComplaintTypes, userType: AccountType)
        case updateCountry(name: String)
        case updateMobileCode(code: String, length: Int)
        case updateMobilePlaceholder(placeholder: String)
        case textField(errorState: Bool, error: String?, textfieldType: ComplaintFormTextFieldTypes)
        case focusField(type: ComplaintFormTextFieldTypes)
        case showError(error: APIResponseError)
        case updateRedemptionPartner(partnerName: String)
    }
    
    // MARK: Lifecycle Methods
    
    init(router: ComplaintFormRouter, type: AccountType, loginState: UserLoginState, complaintType: ComplaintTypes) {
        self.router = router
        self.userType = type
        self.loginState = loginState
        self.complaintType = complaintType
        setupComplaintType()
    }
    
    func viewDidLoad() {
        setupComplaintType()
        if complaintType == .redemptionIssues {
            fetchLoyaltyPartners()
        }
        output?(.nextButtonState(state: false))
        output?(.showTextFields(loggedInState: self.loginState, complaintType: self.complaintType, userType: self.userType))
        
    }
    
    private func setupComplaintType() {
        complaintTypeItemModel = [RadioButtonItemModel(title: complaintType.getTitle(), key: complaintType.rawValue)]
    }
    
    private func fetchLoyaltyPartners() {
        self.output?(.showActivityIndicator(show: true))
        redemptionService.fetchLoyaltyPartners {[weak self] (result) in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                let sortedArr = response.data.sorted(by: { $0.partnerName < $1.partnerName })
                self?.partners.append(contentsOf: sortedArr)
                self?.output?(.showRedemptionPartners)
            case .failure(let error):
                self?.output?(.showError(error: error))
            }
        }
    }
    
    func didSelectPartner(partner: RedemptionPartnerPickerItemModel?) {
        self.partner = partner?.title
        output?(.updateRedemptionPartner(partnerName: partner?.title ?? ""))
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
    
    // MARK: Actions
    
    func nextButtonPressed() {
        var tuple: (Bool, ComplaintFormTextFieldTypes?) = (false, nil)
        
        switch complaintType {
        case .unableToRegister:
            tuple = validateUnableToRegisterComplaintRegex()
        case .unableToReceiveRegistrationCode:
            tuple = validateUnableReceiveRegistrationCodeRegex()
        case .unableToReceiveOTP:
            tuple = validateUnableToReceiveOTPRegex()
        case .unableToAddBeneficiary:
            ()
        case .unableToTransferPointsToBeneficiary:
            ()
        case .unableToSelfAwardPoints:
            ()
        case .redemptionIssues:
            ()
        case .others:
            tuple = validateOthersRegex()
        }
        
        if !tuple.0 {
            if let field = tuple.1 {
                output?(.focusField(type: field))
            }
            return
        }
        
        // API CALL HERE
        submitComplaint()
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
    
    func getRequestModel() -> ComplaintRequestModel {
        let registered = loginState == .loggedIn ? 1 : 0
        let requestModel = ComplaintRequestModel(registered: registered,
                                                 userType: self.userType.rawValue,
                                                 complaintTypeID: self.complaintType.getComplaintTypeCode(),
                                                 mobileNo: self.mobileNumber,
                                                 email: self.email,
                                                 countryOfResidence: self.country?.country,
                                                 mobileOperatorName: self.mobileOperator,
                                                 name: self.name,
                                                 cnic: self.cnic,
                                                 transactionType: nil,
                                                 beneficiaryCnic: nil,
                                                 beneficiaryCountryOfResidence: nil,
                                                 beneficiaryMobileNo: nil,
                                                 beneficiaryMobileOperatorName: nil,
                                                 remittingEntity: nil,
                                                 transactionID: nil,
                                                 transactionDate: nil,
                                                 transactionAmount: nil,
                                                 redemptionPartners: self.partner,
                                                 comments: self.specifyDetails)
        return requestModel
    }
    
    private func submitComplaint() {
        self.output?(.showActivityIndicator(show: true))
        service.submitComplaint(requestModel: getRequestModel()) { [weak self] (result) in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                self?.router.navigateToSuccessScreen(complaintID: response.complaintId)
            case .failure(let error):
                self?.output?(.showError(error: error))
            }
        }
    }
}
    
// MARK: Extension - Validations

extension ComplaintFormViewModel {
    private func validateRequiredFields() {
        
        switch complaintType {
    
        case .unableToRegister:
            validateUnableToRegisterComplaint()
        case .unableToReceiveRegistrationCode:
            validateUnableReceiveRegistrationCode()
        case .unableToReceiveOTP:
            validateUnableToReceiveOTP()
        case .unableToAddBeneficiary:
            ()
        case .unableToTransferPointsToBeneficiary:
            ()
        case .unableToSelfAwardPoints:
            ()
        case .redemptionIssues:
            ()
        case .others:
            validateOthers()
        }
    }
    
    // MARK: Validation - Unable to Register Complaint
    
    private func validateUnableToRegisterComplaint() {
        if name?.isBlank ?? true || cnic?.isBlank ?? true || country == nil || mobileNumber?.isBlank ?? true || specifyDetails?.isBlank ?? true {
            output?(.nextButtonState(state: false))
        } else {
            output?(.nextButtonState(state: true))
        }
    }
    
    private func validateUnableToRegisterComplaintRegex() -> (Bool, ComplaintFormTextFieldTypes?) {
        var isValid: Bool = true

        var errorTopField: ComplaintFormTextFieldTypes?
        
        if name?.isValid(for: RegexConstants.nameRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .fullName))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.nameError.localized, textfieldType: .fullName))
            isValid = false
            errorTopField = errorTopField ?? .fullName
        }
        
        if cnic?.isValid(for: RegexConstants.cnicRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .cnic))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.cnicError.localized, textfieldType: .cnic))
            isValid = false
            errorTopField = errorTopField ?? .cnic
        }

        if country != nil {
            output?(.textField(errorState: false, error: nil, textfieldType: .country))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.countryError.localized, textfieldType: .country))
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
            output?(.textField(errorState: false, error: nil, textfieldType: .email))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.emailError.localized, textfieldType: .email))
            isValid = false
            errorTopField = errorTopField ?? .email
        }
        
        if specifyDetails != nil || !(specifyDetails?.isEmpty ?? true) {
            output?(.textField(errorState: false, error: nil, textfieldType: .specifyDetails))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.specifyDetailsError.localized, textfieldType: .specifyDetails))
            isValid = false
            errorTopField = errorTopField ?? .specifyDetails
        }

        return (isValid, errorTopField)
    }
    
    // MARK: Validation - Unable to Receive OTP
    
    private func validateUnableToReceiveOTP() {
        if country == nil || mobileNumber?.isBlank ?? true || mobileOperator?.isBlank ?? true {
            output?(.nextButtonState(state: false))
        } else {
            if userType == .remitter {
                if name?.isBlank ?? true {
                    output?(.nextButtonState(state: false))
                } else {
                    output?(.nextButtonState(state: true))
                }
            } else {
                output?(.nextButtonState(state: true))
            }
        }
    }
    
    private func validateUnableToReceiveOTPRegex() -> (Bool, ComplaintFormTextFieldTypes?) {
        var isValid: Bool = true
        var errorTopField: ComplaintFormTextFieldTypes?
        
        if userType == .remitter {
            if name?.isValid(for: RegexConstants.nameRegex) ?? false {
                output?(.textField(errorState: false, error: nil, textfieldType: .fullName))
            } else {
                output?(.textField(errorState: true, error: StringConstants.ErrorString.nameError.localized, textfieldType: .fullName))
                isValid = false
                errorTopField = errorTopField ?? .fullName
            }
        }

        if country != nil {
            output?(.textField(errorState: false, error: nil, textfieldType: .country))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.countryError.localized, textfieldType: .country))
            isValid = false
        }

        if country != nil && mobileNumber?.isValid(for: RegexConstants.mobileNumberRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .mobileNumber))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.mobileNumberError.localized, textfieldType: .mobileNumber))
            isValid = false
            errorTopField = errorTopField ?? .mobileNumber
        }

        if mobileOperator != nil || mobileOperator?.isEmpty ?? true {
            output?(.textField(errorState: false, error: nil, textfieldType: .mobileOperatorName))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.genericEmptyFieldError.localized, textfieldType: .mobileOperatorName))
            isValid = false
            errorTopField = errorTopField ?? .mobileOperatorName
        }
        
        if email != nil || email?.isEmpty ?? true || email?.isValid(for: RegexConstants.emailRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .email))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.emailError.localized, textfieldType: .email))
            isValid = false
            errorTopField = errorTopField ?? .email
        }

        return (isValid, errorTopField)
    }
    
    // MARK: Validation - Others
    
    private func validateOthers() {
        if loginState == .loggedIn {
            
        } else {
            validateUnableToRegisterComplaint()
        }
    }
    
    private func validateOthersRegex() -> (Bool, ComplaintFormTextFieldTypes?) {
        if loginState == .loggedIn {
            var isValid: Bool = true
            var errorTopField: ComplaintFormTextFieldTypes?
            
            if specifyDetails != nil || !(specifyDetails?.isEmpty ?? true) {
                output?(.textField(errorState: false, error: nil, textfieldType: .specifyDetails))
            } else {
                output?(.textField(errorState: true, error: StringConstants.ErrorString.specifyDetailsError.localized, textfieldType: .specifyDetails))
                isValid = false
                errorTopField = errorTopField ?? .specifyDetails
            }

            return (isValid, errorTopField)
        }
        return validateUnableToRegisterComplaintRegex()
    }
    
    // MARK: Validation - Unable to Receive Registration Code
    
    private func validateUnableReceiveRegistrationCode() {
        validateUnableToReceiveOTP()
    }
    
    private func validateUnableReceiveRegistrationCodeRegex() -> (Bool, ComplaintFormTextFieldTypes?) {
        return validateUnableToReceiveOTPRegex()
    }
}

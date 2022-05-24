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
    var transactionType: String? { get set }
    var beneficiaryCnic: String? { get set }
    var beneficiaryMobileNo: String? { get set }
    var beneficiaryMobileOperator: String? { get set }
    var remittanceEntity: String? { get set }
    var transactionID: String? { get set }
    var transactionDate: Date? { get set }
    var transactionAmount: String? { get set }
    
    var partnerPickerViewModel: ItemPickerViewModel { get }
    var transactionTypesPickerViewModel: ItemPickerViewModel { get }
    var datePickerViewModel: CustomDatePickerViewModel { get }
    
    var complaintTypeItemModel: [RadioButtonItemModel] { get }
    
    func viewDidLoad()
    func nextButtonPressed()
    func countryTextFieldTapped(isBeneficiary: Bool)
    func didSelectPartner(partner: RedemptionPartnerPickerItemModel?)
    func didSelectTransactionType(type: TransactionTypesPickerItemModel?)
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
    
    var beneficiaryCountry: Country? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var beneficiaryMobileNo: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var beneficiaryMobileOperator: String? {
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
    
    var transactionType: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var beneficiaryCnic: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var remittanceEntity: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var transactionID: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var transactionDate: Date? {
        didSet {
            validateRequiredFields()
            self.output?(.updateTransactionDate(dateStr: transactionDateString ?? ""))
        }
    }
    
    var transactionAmount: String? {
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
    
    var transactionTypesPickerViewModel: ItemPickerViewModel {
        if complaintType == .unableToReceiveOTP && loginState == .loggedIn {
            var dataArray: [PickerItemModel] = []
            for type in transactionTypesArr {
                dataArray.append(TransactionTypesPickerItemModel(title: type.localized, key: "\(type)"))
            }
            return ItemPickerViewModel(data: dataArray)
        }
        return ItemPickerViewModel(data: [])
    }
    
    var datePickerViewModel: CustomDatePickerViewModel {
        return CustomDatePickerViewModel(maxDate: Date())
    }
    
    private var transactionDateString: String? {
        if let date = transactionDate {
            return DateFormat().formatDateString(to: date, formatter: .shortDateFormat)
        } else {
            return nil
        }
    }
    
    // MARK: Generic Properties
    
    private var router: ComplaintFormRouter
    var output: ComplaintFormViewModelOutput?
    private var userType: AccountType
    private var loginState: UserLoginState
    private var complaintType: ComplaintTypes
    
    private var redemptionService: RedeemService = RedeemService()
    private var partners: [Partner] = []
    private var transactionTypesArr: [String] = []
    
    private var service = ComplaintService()
    
    private var currentUser: UserModel?
    
    var complaintTypeItemModel: [RadioButtonItemModel] = []
    
    // MARK: Output
    
    enum Output {
        case showTransactionTypes
        case showRedemptionPartners
        case showActivityIndicator(show: Bool)
        case nextButtonState(state: Bool)
        case showTextFields(loggedInState: UserLoginState, complaintType: ComplaintTypes, userType: AccountType)
        case updateCountry(name: String, isBeneficiary: Bool)
        case updateMobileCode(code: String, length: Int, isBeneficiary: Bool)
        case updateMobilePlaceholder(placeholder: String, isBeneficiary: Bool)
        case textField(errorState: Bool, error: String?, textfieldType: ComplaintFormTextFieldTypes)
        case focusField(type: ComplaintFormTextFieldTypes)
        case showError(error: APIResponseError)
        case updateRedemptionPartner(partnerName: String)
        case updateTransactionType(type: String)
        case updateTransactionDate(dateStr: String)
        case requestNotification(complaintId: String, message: String)
    }
    
    // MARK: Lifecycle Methods
    
    init(router: ComplaintFormRouter, type: AccountType, loginState: UserLoginState, complaintType: ComplaintTypes, currentUser: UserModel?) {
        self.router = router
        self.userType = type
        self.loginState = loginState
        self.complaintType = complaintType
        self.currentUser = currentUser
        setupComplaintType()
    }
    
    func viewDidLoad() {
        setupComplaintType()
        if complaintType == .redemptionIssues {
            fetchLoyaltyPartners()
        }
        if complaintType == .unableToReceiveOTP && loginState == .loggedIn {
            fetchTransactionTypes()
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
    
    private func fetchTransactionTypes() {
        self.output?(.showActivityIndicator(show: true))
        service.getTransactionTypes { [weak self] (result) in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                self?.transactionTypesArr.append(contentsOf: response.data)
                if let user = self?.currentUser, user.accountType == .beneficiary {
                    if let index = self?.transactionTypesArr.firstIndex(of: "Self Awarding") {
                        self?.transactionTypesArr.remove(at: index)
                    }
                }
                self?.output?(.showTransactionTypes)
            case .failure(let error):
                self?.output?(.showError(error: error))
            }
        }
    }
    
    func didSelectPartner(partner: RedemptionPartnerPickerItemModel?) {
        self.partner = partner?.title
        output?(.updateRedemptionPartner(partnerName: partner?.title ?? ""))
    }
    
    func didSelectTransactionType(type: TransactionTypesPickerItemModel?) {
        self.transactionType = type?.title
        output?(.updateTransactionType(type: type?.title.localized ?? ""))
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
            tuple = validateUnableToAddBeneficiaryRegex()
        case .unableToTransferPointsToBeneficiary:
            tuple = validateUnableToTransferPointsToBeneficiaryRegex()
        case .unableToSelfAwardPoints:
            tuple = validateUnableToSelfAwardPointsRegex()
        case .redemptionIssues:
            tuple = validateRedemptionIssuesRegex()
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
    
    func countryTextFieldTapped(isBeneficiary: Bool) {
        router.navigateToCountryPicker(with: { [weak self] selectedCountry in
            if isBeneficiary {
                if self?.beneficiaryCountry != selectedCountry {
                    self?.beneficiaryCountry = selectedCountry
                    self?.output?(.updateCountry(name: selectedCountry.country, isBeneficiary: true))
                    self?.output?(.updateMobileCode(code: selectedCountry.code + " - ", length: selectedCountry.length, isBeneficiary: true))
                    self?.output?(.updateMobilePlaceholder(placeholder: Array(repeating: "x".localized, count: selectedCountry.length).joined(), isBeneficiary: true))
                }
            } else {
                if self?.country != selectedCountry {
                    self?.country = selectedCountry
                    self?.output?(.updateCountry(name: selectedCountry.country, isBeneficiary: false))
                    self?.output?(.updateMobileCode(code: selectedCountry.code + " - ", length: selectedCountry.length, isBeneficiary: false))
                    self?.output?(.updateMobilePlaceholder(placeholder: Array(repeating: "x".localized, count: selectedCountry.length).joined(), isBeneficiary: false))
                }
            }
        }, accountType: self.userType)
    }
    
    func getRequestModel() -> ComplaintRequestModel {
        var beneficiaryMobile: String?
        var newMobileNumber: String?
        if let beneficiaryCountry = self.beneficiaryCountry, let beneficiaryMobileNo = self.beneficiaryMobileNo {
            beneficiaryMobile = "\(beneficiaryCountry.code)\(beneficiaryMobileNo)"
        }
        if let country = self.country, let mobileNumber = self.mobileNumber {
            newMobileNumber = "\(country.code)\(mobileNumber)"
        }
        let registered = loginState == .loggedIn ? 1 : 0
        let requestModel = ComplaintRequestModel(registered: registered,
                                                 userType: self.userType.rawValue,
                                                 complaintTypeID: self.complaintType.getComplaintTypeCode(),
                                                 mobileNo: self.currentUser?.mobileNo ?? newMobileNumber,
                                                 email: self.currentUser?.email ?? self.email,
                                                 countryOfResidence: self.currentUser?.countryName ?? self.country?.country,
                                                 mobileOperatorName: self.mobileOperator,
                                                 name: self.currentUser?.fullName ?? self.name,
                                                 cnic: self.currentUser?.cnicNicop.toString() ?? self.cnic,
                                                 transactionType: self.transactionType,
                                                 beneficiaryCnic: self.beneficiaryCnic,
                                                 beneficiaryCountryOfResidence: self.beneficiaryCountry?.country,
                                                 beneficiaryMobileNo: beneficiaryMobile,
                                                 beneficiaryMobileOperatorName: self.beneficiaryMobileOperator,
                                                 remittingEntity: self.remittanceEntity,
                                                 transactionID: self.transactionID,
                                                 transactionDate: self.transactionDateString,
                                                 transactionAmount: self.transactionAmount,
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
                self?.output?(.requestNotification(complaintId: response.complaintId, message: response.message))
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
            validateUnableToAddBeneficiary()
        case .unableToTransferPointsToBeneficiary:
            validateUnableToTransferPointsToBeneficiary()
        case .unableToSelfAwardPoints:
            validateUnableToSelfAwardPoints()
        case .redemptionIssues:
            validateRedemptionIssues()
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
        switch loginState {
        case .loggedIn:
            if transactionType?.isBlank ?? true || mobileOperator?.isBlank ?? true {
                output?(.nextButtonState(state: false))
            } else {
                output?(.nextButtonState(state: true))
            }
        case .loggedOut:
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
    }
    
    private func validateUnableToReceiveOTPRegex() -> (Bool, ComplaintFormTextFieldTypes?) {
        var isValid: Bool = true
        var errorTopField: ComplaintFormTextFieldTypes?
        
        switch loginState {
        case .loggedIn:
            if mobileOperator != nil || mobileOperator?.isEmpty ?? true {
                output?(.textField(errorState: false, error: nil, textfieldType: .mobileOperatorName))
            } else {
                output?(.textField(errorState: true, error: StringConstants.ErrorString.genericEmptyFieldError.localized, textfieldType: .mobileOperatorName))
                isValid = false
                errorTopField = errorTopField ?? .mobileOperatorName
            }
            
            if transactionType != nil || transactionType?.isEmpty ?? true {
                output?(.textField(errorState: false, error: nil, textfieldType: .transactionType))
            } else {
                output?(.textField(errorState: true, error: StringConstants.ErrorString.genericEmptyFieldError.localized, textfieldType: .transactionType))
                isValid = false
                errorTopField = errorTopField ?? .transactionType
            }
        case .loggedOut:
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
        }
        
        return (isValid, errorTopField)

    }
    
    // MARK: Validation - Others
    
    private func validateOthers() {
        if loginState == .loggedIn {
            if specifyDetails?.isBlank ?? true {
                output?(.nextButtonState(state: false))
            } else {
                output?(.nextButtonState(state: true))
            }
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
    
    // MARK: Validation - Unable to Add Beneficiary
    
    private func validateUnableToAddBeneficiary() {
        if beneficiaryCnic?.isBlank ?? true || beneficiaryCountry == nil || beneficiaryMobileNo?.isBlank ?? true || beneficiaryMobileOperator?.isBlank ?? true {
            output?(.nextButtonState(state: false))
        } else {
            output?(.nextButtonState(state: true))
        }
    }
    
    private func validateUnableToAddBeneficiaryRegex() -> (Bool, ComplaintFormTextFieldTypes?) {
        var isValid: Bool = true
        var errorTopField: ComplaintFormTextFieldTypes?
        
        if beneficiaryCnic?.isValid(for: RegexConstants.cnicRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .beneficiaryCnic))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.cnicError.localized, textfieldType: .beneficiaryCnic))
            isValid = false
            errorTopField = errorTopField ?? .beneficiaryCnic
        }
        
        if beneficiaryCountry != nil {
            output?(.textField(errorState: false, error: nil, textfieldType: .beneficiaryCountry))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.countryError.localized, textfieldType: .beneficiaryCountry))
            isValid = false
            errorTopField = errorTopField ?? .beneficiaryCountry
        }

        if beneficiaryCountry != nil && beneficiaryMobileNo?.isValid(for: RegexConstants.mobileNumberRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .beneficiraryMobieNo))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.mobileNumberError.localized, textfieldType: .beneficiraryMobieNo))
            isValid = false
            errorTopField = errorTopField ?? .beneficiraryMobieNo
        }

        if beneficiaryMobileOperator != nil || beneficiaryMobileOperator?.isEmpty ?? true {
            output?(.textField(errorState: false, error: nil, textfieldType: .beneficiaryMobileOperator))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.genericEmptyFieldError.localized, textfieldType: .beneficiaryMobileOperator))
            isValid = false
            errorTopField = errorTopField ?? .beneficiaryMobileOperator
        }
        
        return (isValid, errorTopField)
    }
    
    // MARK: Validation - Unable to Transfer points to Beneficiary
    
    private func validateUnableToTransferPointsToBeneficiary() {
        if beneficiaryCnic?.isBlank ?? true {
            output?(.nextButtonState(state: false))
        } else {
            output?(.nextButtonState(state: true))
        }
    }
    
    private func validateUnableToTransferPointsToBeneficiaryRegex() -> (Bool, ComplaintFormTextFieldTypes?) {
        var isValid: Bool = true
        var errorTopField: ComplaintFormTextFieldTypes?
        
        if beneficiaryCnic?.isValid(for: RegexConstants.cnicRegex) ?? false {
            output?(.textField(errorState: false, error: nil, textfieldType: .beneficiaryCnic))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.cnicError.localized, textfieldType: .beneficiaryCnic))
            isValid = false
            errorTopField = errorTopField ?? .beneficiaryCnic
        }
        
        return (isValid, errorTopField)
    }
    
    // MARK: Validation - Unable to Self Award Points
    
    private func validateUnableToSelfAwardPoints() {
        if beneficiaryCnic?.isBlank ?? true || remittanceEntity?.isBlank ?? true || transactionID?.isBlank ?? true || transactionDateString?.isBlank ?? true || transactionAmount?.isBlank ?? true || !(transactionAmount?.isValid(for: RegexConstants.transactionAmountRegex) ?? false) || !(beneficiaryCnic?.isValid(for: RegexConstants.alphanuericRegex) ?? false) {
            output?(.nextButtonState(state: false))
        } else {
            output?(.nextButtonState(state: true))
        }
    }
    
    private func validateUnableToSelfAwardPointsRegex() -> (Bool, ComplaintFormTextFieldTypes?) {
        var isValid: Bool = true
        var errorTopField: ComplaintFormTextFieldTypes?
        
        if !(beneficiaryCnic?.isBlank ?? true) {
            output?(.textField(errorState: false, error: nil, textfieldType: .beneficiaryAccount))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.genericEmptyFieldError.localized, textfieldType: .beneficiaryAccount))
            isValid = false
            errorTopField = errorTopField ?? .beneficiaryAccount
        }
        
        if remittanceEntity != nil {
            output?(.textField(errorState: false, error: nil, textfieldType: .remittingEntity))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.genericEmptyFieldError.localized, textfieldType: .remittingEntity))
            isValid = false
            errorTopField = errorTopField ?? .remittingEntity
        }
        
        if !(transactionID?.isBlank ?? true) {
            output?(.textField(errorState: false, error: nil, textfieldType: .transactionID))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.genericEmptyFieldError.localized, textfieldType: .transactionID))
            isValid = false
            errorTopField = errorTopField ?? .transactionID
        }
        
        if transactionDateString != nil || transactionDate != nil {
            output?(.textField(errorState: false, error: nil, textfieldType: .transactionDate))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.genericEmptyFieldError.localized, textfieldType: .transactionDate))
            isValid = false
            errorTopField = errorTopField ?? .transactionDate
        }
        
        if !(transactionAmount?.isBlank ?? true) {
            output?(.textField(errorState: false, error: nil, textfieldType: .transactionAmount))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.genericEmptyFieldError.localized, textfieldType: .transactionAmount))
            isValid = false
            errorTopField = errorTopField ?? .transactionAmount
        }
        
        return (isValid, errorTopField)
    }
    
    // MARK: Validation - Redemption Issues
    
    private func validateRedemptionIssues() {
        if partner?.isBlank ?? true || specifyDetails?.isBlank ?? true {
            output?(.nextButtonState(state: false))
        } else {
            output?(.nextButtonState(state: true))
        }
    }
    
    private func validateRedemptionIssuesRegex() -> (Bool, ComplaintFormTextFieldTypes?) {
        var isValid: Bool = true
        var errorTopField: ComplaintFormTextFieldTypes?
        
        if !(partner?.isBlank ?? true) {
            output?(.textField(errorState: false, error: nil, textfieldType: .redemptionIssue))
        } else {
            output?(.textField(errorState: true, error: StringConstants.ErrorString.genericEmptyFieldError.localized, textfieldType: .redemptionIssue))
            isValid = false
            errorTopField = errorTopField ?? .redemptionIssue
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
    
}

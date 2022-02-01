//
//  ComplaintFormViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 26/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class ComplaintFormViewController: BaseViewController {
    
    // MARK: Properties
    
    var viewModel: ComplaintFormViewModel!
    private lazy var itemPickerView: ItemPickerView! = {
        var pickerView = ItemPickerView()
        pickerView.toolbarDelegate = self
        pickerView.viewModel = viewModel.partnerPickerViewModel
        return pickerView
    }()
    private lazy var transactionTypesItemPickerView: ItemPickerView! = {
        var pickerView = ItemPickerView()
        pickerView.toolbarDelegate = self
        pickerView.viewModel = viewModel.transactionTypesPickerViewModel
        return pickerView
    }()
    
    // MARK: IBOutlets

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "Complaint Management".localized
            titleLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .extraUltraLargeFontSize)
            titleLabel.textColor = UIColor.init(commonColor: .appGreen)
        }
    }
    
    @IBOutlet weak var complaintLabel: UILabel! {
        didSet {
            complaintLabel.text = "Complaint Type".localized
            complaintLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .extraUltraLargeFontSize)
            complaintLabel.textColor = UIColor.init(commonColor: .appDarkGray)
        }
    }
    
    @IBOutlet weak var complaintTypeRadioButton: RadioButtonView! {
        didSet {
            complaintTypeRadioButton.alignment = .vertical
            complaintTypeRadioButton.setRadioButtonItems(items: viewModel.complaintTypeItemModel)
            complaintTypeRadioButton.setRadioItemSelected(at: 0, isSelected: true)
        }
    }
    
    @IBOutlet weak var nextButton: PrimaryCTAButton! {
        didSet {
            nextButton.setTitle("Next".localized, for: .normal)
        }
    }
    
    @IBOutlet private weak var fullNameTextView: LabelledTextview! {
        didSet {
            fullNameTextView.titleLabelText = "Name".localized
            fullNameTextView.placeholderText = "Muhammad Ali".localized
            fullNameTextView.autoCapitalizationType = .words
            fullNameTextView.inputFieldMaxLength = 50
            fullNameTextView.editTextKeyboardType = .asciiCapable
            fullNameTextView.formatValidator = FormatValidator(regex: RegexConstants.nameRegex, invalidFormatError: StringConstants.ErrorString.nameError.localized)
            fullNameTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.name = updatedText
            }
        }
    }
    @IBOutlet private weak var cnicTextView: LabelledTextview! {
        didSet {
            cnicTextView.titleLabelText = "CNIC/NICOP Number".localized
            cnicTextView.placeholderText = "xxxxx-xxxxxxx-x".localized
            cnicTextView.editTextKeyboardType = .asciiCapableNumberPad
            cnicTextView.inputFieldMinLength = 13
            cnicTextView.inputFieldMaxLength = 13
            cnicTextView.formatValidator = CNICFormatValidator(regex: RegexConstants.cnicRegex, invalidFormatError: StringConstants.ErrorString.cnicError.localized)
            cnicTextView.formatter = CNICFormatter()
            cnicTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.cnic = updatedText
            }
        }
    }
    @IBOutlet private weak var countryTextView: LabelledTextview! {
        didSet {
            countryTextView.titleLabelText = "Country of Residence".localized
            countryTextView.placeholderText = "Select Country".localized
            countryTextView.isEditable = false
            countryTextView.isTappable = true
            countryTextView.editTextKeyboardType = .asciiCapable
            countryTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            countryTextView.onTextFieldTapped = { [weak self] in
                guard let self = self else { return }
                self.viewModel.countryTextFieldTapped(isBeneficiary: false)
            }
        }
    }
    @IBOutlet private weak var mobileNumberTextView: LabelledTextview! {
        didSet {
            mobileNumberTextView.titleLabelText = "Mobile Number".localized
            mobileNumberTextView.placeholderText = "+xx xxx xxx xxxx".localized
            mobileNumberTextView.editTextKeyboardType = .asciiCapableNumberPad
            mobileNumberTextView.isEditable = false
            mobileNumberTextView.formatValidator = FormatValidator(regex: RegexConstants.mobileNumberRegex, invalidFormatError: StringConstants.ErrorString.mobileNumberError.localized)
            mobileNumberTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.mobileNumber = updatedText
            }
        }
    }
    @IBOutlet private weak var mobileOperatorTextView: LabelledTextview! {
        didSet {
            mobileOperatorTextView.titleLabelText = "Mobile Operator Name".localized
            mobileOperatorTextView.placeholderText = "Jazz".localized
            mobileOperatorTextView.autoCapitalizationType = .words
            mobileOperatorTextView.editTextKeyboardType = .asciiCapable
            mobileOperatorTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.mobileOperator = updatedText
            }
        }
    }
    @IBOutlet private weak var emailAddressTextView: LabelledTextview! {
        didSet {
            emailAddressTextView.titleLabelText = "Email Address (Optional)".localized
            emailAddressTextView.placeholderText = "abc@abc.com".localized
            emailAddressTextView.editTextKeyboardType = .emailAddress
            emailAddressTextView.formatValidator = FormatValidator(regex: RegexConstants.emailRegex, invalidFormatError: StringConstants.ErrorString.emailError.localized)
            emailAddressTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.email = updatedText
            }
        }
    }
    
    @IBOutlet weak var redemptionIssueTextView: LabelledTextview! {
        didSet {
            redemptionIssueTextView.titleLabelText = "Redemption Issues".localized
            redemptionIssueTextView.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            redemptionIssueTextView.placeholderText = "Select Redemption Partner".localized
            redemptionIssueTextView.editTextCursorColor = .init(white: 1, alpha: 0)
        }
    }
    
    @IBOutlet weak var transactionTypesTextView: LabelledTextview! {
        didSet {
            transactionTypesTextView.titleLabelText = "Transaction Type".localized
            transactionTypesTextView.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            transactionTypesTextView.placeholderText = "Select Transaction Type".localized
            transactionTypesTextView.editTextCursorColor = .init(white: 1, alpha: 0)
        }
    }
    
    @IBOutlet private weak var beneficiaryCnicTextView: LabelledTextview! {
        didSet {
            beneficiaryCnicTextView.titleLabelText = "Beneficiary CNIC/NICOP".localized
            beneficiaryCnicTextView.placeholderText = "xxxxx-xxxxxxx-x".localized
            beneficiaryCnicTextView.editTextKeyboardType = .asciiCapableNumberPad
            beneficiaryCnicTextView.inputFieldMinLength = 13
            beneficiaryCnicTextView.inputFieldMaxLength = 13
            beneficiaryCnicTextView.formatValidator = CNICFormatValidator(regex: RegexConstants.cnicRegex, invalidFormatError: StringConstants.ErrorString.cnicError.localized)
            beneficiaryCnicTextView.formatter = CNICFormatter()
            beneficiaryCnicTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.beneficiaryCnic = updatedText
            }
        }
    }
    
    @IBOutlet private weak var beneficiaryCountryTextView: LabelledTextview! {
        didSet {
            beneficiaryCountryTextView.titleLabelText = "Beneficiary Country of Residence".localized
            beneficiaryCountryTextView.placeholderText = "Select Country".localized
            beneficiaryCountryTextView.isEditable = false
            beneficiaryCountryTextView.isTappable = true
            beneficiaryCountryTextView.editTextKeyboardType = .asciiCapable
            beneficiaryCountryTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            beneficiaryCountryTextView.onTextFieldTapped = { [weak self] in
                guard let self = self else { return }
                self.viewModel.countryTextFieldTapped(isBeneficiary: true)
            }
        }
    }
    @IBOutlet private weak var beneficiaryMobileNumberTextView: LabelledTextview! {
        didSet {
            beneficiaryMobileNumberTextView.titleLabelText = "Beneficiary Mobile Number".localized
            beneficiaryMobileNumberTextView.placeholderText = "+xx xxx xxx xxxx".localized
            beneficiaryMobileNumberTextView.editTextKeyboardType = .asciiCapableNumberPad
            beneficiaryMobileNumberTextView.isEditable = false
            beneficiaryMobileNumberTextView.formatValidator = FormatValidator(regex: RegexConstants.mobileNumberRegex, invalidFormatError: StringConstants.ErrorString.mobileNumberError.localized)
            beneficiaryMobileNumberTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.beneficiaryMobileNo = updatedText
            }
        }
    }
    @IBOutlet private weak var beneficiaryMobileOperatorTextView: LabelledTextview! {
        didSet {
            beneficiaryMobileOperatorTextView.titleLabelText = "Beneficiary Mobile Operator Name".localized
            beneficiaryMobileOperatorTextView.placeholderText = "Jazz".localized
            beneficiaryMobileOperatorTextView.autoCapitalizationType = .words
            beneficiaryMobileOperatorTextView.editTextKeyboardType = .asciiCapable
            beneficiaryMobileOperatorTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.beneficiaryMobileOperator = updatedText
            }
        }
    }
    @IBOutlet private weak var specifyDetailsTextArea: LabelledTextArea! {
        didSet {
            specifyDetailsTextArea.titleLabelText = "Specify Details".localized
            specifyDetailsTextArea.inputTextAreaMaxLength = 300
            specifyDetailsTextArea.isEditable = true
            specifyDetailsTextArea.inputText = ""
            specifyDetailsTextArea.editTextKeyboardType = .asciiCapable
            specifyDetailsTextArea.onTextAreaChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.specifyDetails = updatedText
            }
        }
    }
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        hideAllTextFields()
        bindViewModelOutput()
        super.viewDidLoad()

        viewModel.viewDidLoad()
    }
    
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .nextButtonState(state: let state):
                self.nextButton.isEnabled = state
            case .showTextFields(loggedInState: let state, complaintType: let complaint, userType: let user):
                self.showTextFields(state: state, complaint: complaint, user: user)
            case .updateCountry(name: let name, isBeneficiary: let isBeneficiary):
                if isBeneficiary {
                    self.beneficiaryCountryTextView.inputText = name
                    return
                }
                self.countryTextView.inputText = name
            case .updateMobileCode(let code, _, isBeneficiary: let isBeneficiary):
                if isBeneficiary {
                    self.beneficiaryMobileNumberTextView.leadingText = code
                    self.beneficiaryMobileNumberTextView.inputFieldMinLength = 1
                    self.beneficiaryMobileNumberTextView.isEditable = true
                    self.beneficiaryMobileNumberTextView.inputText = ""
                    self.beneficiaryMobileNumberTextView.becomeFirstResponder()
                    return
                }
                self.mobileNumberTextView.leadingText = code
                self.mobileNumberTextView.inputFieldMinLength = 1
//                self.mobileNumberTextView.inputFieldMaxLength = numberLength
                self.mobileNumberTextView.isEditable = true
                self.mobileNumberTextView.inputText = ""
                self.mobileNumberTextView.becomeFirstResponder()
            case .updateMobilePlaceholder(let placeholder, isBeneficiary: let isBeneficiary):
                if isBeneficiary {
                    self.beneficiaryMobileNumberTextView.placeholderText = placeholder
                    return
                }
                self.mobileNumberTextView.placeholderText = placeholder
            case .textField(errorState: let errorState, error: let error, textfieldType: let textfieldType):
                setTextFieldErrorState(state: errorState, message: error, textfield: textfieldType)
            case .focusField(type: let type):
                self.focusFields(type: type)
            case .showError(error: let error):
                self.showAlert(with: error)
            case .showRedemptionPartners:
                redemptionIssueTextView.inputTextFieldInputPickerView = itemPickerView
            case .showActivityIndicator(show: let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .updateRedemptionPartner(partnerName: let partner):
                redemptionIssueTextView.inputText = partner
            case .showTransactionTypes:
                transactionTypesTextView.inputTextFieldInputPickerView = transactionTypesItemPickerView
            case .updateTransactionType(type: let type):
                transactionTypesTextView.inputText = type
            }
        }
    }
    
    // MARK: IBActions
    
    @IBAction func nextButtonAction(_ sender: Any) {
        viewModel.nextButtonPressed()
    }
    
}

// MARK: Extension - Cases

extension ComplaintFormViewController {
    // MARK: Unregistered Remitter
    
    private func showUnregisteredRemitterFields(complaint: ComplaintTypes) {
        switch complaint {
        case .unableToRegister:
            fullNameTextView.isHidden = false
            cnicTextView.isHidden = false
            countryTextView.isHidden = false
            mobileNumberTextView.isHidden = false
            emailAddressTextView.isHidden = false
            specifyDetailsTextArea.isHidden = false
        case .unableToReceiveOTP:
            fullNameTextView.isHidden = false
            countryTextView.isHidden = false
            mobileNumberTextView.isHidden = false
            mobileOperatorTextView.isHidden = false
            emailAddressTextView.isHidden = false
        case .others:
            fullNameTextView.isHidden = false
            cnicTextView.isHidden = false
            countryTextView.isHidden = false
            mobileNumberTextView.isHidden = false
            emailAddressTextView.isHidden = false
            specifyDetailsTextArea.isHidden = false
        default:
            hideAllTextFields()
        }
    }
    
    // MARK: Registered Remitter
    
    private func showRegisteredRemitterFields(complaint: ComplaintTypes) {
        switch complaint {
        case .unableToReceiveOTP:
            mobileOperatorTextView.isHidden = false
            transactionTypesTextView.isHidden = false
        case .unableToAddBeneficiary:
            beneficiaryCnicTextView.isHidden = false
            beneficiaryCountryTextView.isHidden = false
            beneficiaryMobileNumberTextView.isHidden = false
            beneficiaryMobileOperatorTextView.isHidden = false
        case .unableToTransferPointsToBeneficiary:
            beneficiaryCnicTextView.isHidden = false
        case .unableToSelfAwardPoints:
            ()
        case .redemptionIssues:
            redemptionIssueTextView.isHidden = false
            specifyDetailsTextArea.isHidden = false
        case .others:
            specifyDetailsTextArea.isHidden = false
        default:
            hideAllTextFields()
        }
    }
    
    // MARK: Unregistered Beneficiary
    
    private func showUnregisteredBeneficiaryFields(complaint: ComplaintTypes) {
        switch complaint {
        
        case .unableToRegister:
            fullNameTextView.isHidden = false
            cnicTextView.isHidden = false
            countryTextView.isHidden = false
            mobileNumberTextView.isHidden = false
            emailAddressTextView.isHidden = false
            specifyDetailsTextArea.isHidden = false
        case .unableToReceiveRegistrationCode:
            countryTextView.isHidden = false
            mobileNumberTextView.isHidden = false
            mobileOperatorTextView.isHidden = false
            emailAddressTextView.isHidden = false
        case .others:
            fullNameTextView.isHidden = false
            cnicTextView.isHidden = false
            countryTextView.isHidden = false
            mobileNumberTextView.isHidden = false
            emailAddressTextView.isHidden = false
            specifyDetailsTextArea.isHidden = false
        default:
            hideAllTextFields()
        }
    }
    
    // MARK: Registered Beneficiary
    
    private func showRegisteredBeneficiaryFields(complaint: ComplaintTypes) {
        switch complaint {
        case .unableToReceiveOTP:
            ()
        case .redemptionIssues:
            ()
        case .others:
            ()
        default:
            hideAllTextFields()
        }
    }
}

// MARK: Extension - TextField Functions

extension ComplaintFormViewController {
    
    private func showTextFields(state: UserLoginState, complaint: ComplaintTypes, user: AccountType) {
        switch state {
        case .loggedIn:
            hideAllTextFields()
            if user == .remitter {
                showRegisteredRemitterFields(complaint: complaint)
            } else {
                showRegisteredBeneficiaryFields(complaint: complaint)
            }
        case .loggedOut:
            hideAllTextFields()
            if user == .remitter {
                showUnregisteredRemitterFields(complaint: complaint)
            } else {
                showUnregisteredBeneficiaryFields(complaint: complaint)
            }
        }
    }
    
    private func hideAllTextFields() {
        fullNameTextView.isHidden = true
        cnicTextView.isHidden = true
        countryTextView.isHidden = true
        mobileNumberTextView.isHidden = true
        mobileOperatorTextView.isHidden = true
        emailAddressTextView.isHidden = true
        redemptionIssueTextView.isHidden = true
        transactionTypesTextView.isHidden = true
        beneficiaryCnicTextView.isHidden = true
        beneficiaryCountryTextView.isHidden = true
        beneficiaryMobileNumberTextView.isHidden = true
        beneficiaryMobileOperatorTextView.isHidden = true
        specifyDetailsTextArea.isHidden = true
    }

    private func setTextFieldErrorState(state: Bool, message: String?, textfield: ComplaintFormTextFieldTypes) {
        switch textfield {
        case .fullName:
            fullNameTextView.updateStateTo(isError: state, error: message)
        case .cnic:
            cnicTextView.updateStateTo(isError: state, error: message)
        case .country:
            countryTextView.updateStateTo(isError: state, error: message)
        case .mobileNumber:
            mobileNumberTextView.updateStateTo(isError: state, error: message)
        case .mobileOperatorName:
            mobileOperatorTextView.updateStateTo(isError: state, error: message)
        case .email:
            emailAddressTextView.updateStateTo(isError: state, error: message)
        case .transactionType:
            transactionTypesTextView.updateStateTo(isError: state, error: message)
        case .specifyDetails:
            specifyDetailsTextArea.updateStateTo(isError: state, error: message)
        case .beneficiaryCnic:
            beneficiaryCnicTextView.updateStateTo(isError: state, error: message)
        case .beneficiaryCountry:
            beneficiaryCountryTextView.updateStateTo(isError: state, error: message)
        case .beneficiraryMobieNo:
            beneficiaryMobileNumberTextView.updateStateTo(isError: state, error: message)
        case .beneficiaryMobileOperator:
            beneficiaryMobileOperatorTextView.updateStateTo(isError: state, error: message)
        }
    }
    
    private func focusFields(type: ComplaintFormTextFieldTypes) {
        switch type {
        case .fullName:
            fullNameTextView.becomeFirstResponder()
        case .cnic:
            cnicTextView.becomeFirstResponder()
        case .country:
            countryTextView.becomeFirstResponder()
        case .mobileNumber:
            mobileNumberTextView.becomeFirstResponder()
        case .mobileOperatorName:
            mobileOperatorTextView.becomeFirstResponder()
        case .email:
            emailAddressTextView.becomeFirstResponder()
        case .transactionType:
            transactionTypesTextView.becomeFirstResponder()
        case .specifyDetails:
            specifyDetailsTextArea.becomeFirstResponder()
        case .beneficiaryCnic:
            beneficiaryCnicTextView.becomeFirstResponder()
        case .beneficiaryCountry:
            beneficiaryCountryTextView.becomeFirstResponder()
        case .beneficiraryMobieNo:
            beneficiaryMobileNumberTextView.becomeFirstResponder()
        case .beneficiaryMobileOperator:
            beneficiaryMobileOperatorTextView.becomeFirstResponder()
        }
    }
}

// MARK: Extension - ItemPickerViewDelegate

extension ComplaintFormViewController: ItemPickerViewDelegate {
    func didTapCancelButton() {
        self.view.endEditing(true)
    }

    func didTapDoneButton(with selectedItem: PickerItemModel?) {
        if let item = selectedItem as? RedemptionPartnerPickerItemModel {
            viewModel.didSelectPartner(partner: item)
        }
        if let item = selectedItem as? TransactionTypesPickerItemModel {
            viewModel.didSelectTransactionType(type: item)
        }
        self.view.endEditing(true)
    }
}

// MARK: Extension - Initializable

extension ComplaintFormViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.complaintForm
    }
}



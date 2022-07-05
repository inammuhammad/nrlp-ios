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
    
    private lazy var transactionTypesItemPickerView: ItemPickerView! = {
        var pickerView = ItemPickerView()
        pickerView.toolbarDelegate = self
        pickerView.viewModel = viewModel.transactionTypesPickerViewModel
        return pickerView
    }()
    private lazy var transactionDatePicker: CustomDatePickerView = {
        var pickerView = CustomDatePickerView()
        pickerView.toolbarDelegate = self
        pickerView.isSelfAward = true
        pickerView.viewModel = viewModel.datePickerViewModel
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
            redemptionIssueTextView.titleLabelText = "Redemption Partner".localized
            redemptionIssueTextView.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            redemptionIssueTextView.placeholderText = "Select Redemption Partner".localized
            redemptionIssueTextView.editTextCursorColor = .init(white: 1, alpha: 0)
        }
    }
        
    // Branch Center for USC and BE&OE
    @IBOutlet private weak var branchTextView: LabelledTextview! {
        didSet {
            branchTextView.titleLabelText = "Branch/Center".localized
            // branchTextView.placeholderText = "Select Country".localized
            branchTextView.isEditable = false
            branchTextView.isTappable = true
            branchTextView.showHelpBtn = true
            branchTextView.helpLabelText = "Mention visiting Branch/Center".localized
            branchTextView.editTextKeyboardType = .asciiCapable
            branchTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            branchTextView.onTextFieldTapped = { [weak self] in
                guard let self = self else { return }
                // self.viewModel.countryTextFieldTapped()
            }
            branchTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
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
    
    @IBOutlet weak var selfAwardTransactionTypeTextView: LabelledTextview! {
        didSet {
            selfAwardTransactionTypeTextView.titleLabelText = "Remittance Transaction Type".localized
            selfAwardTransactionTypeTextView.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            selfAwardTransactionTypeTextView.placeholderText = "Select Transaction Type".localized
            selfAwardTransactionTypeTextView.showHelpBtn = true
            selfAwardTransactionTypeTextView.helpPopupIcon = .selfAward
            selfAwardTransactionTypeTextView.helpLabelText = "Enter Beneficiary Account Number/ IBAN/CNIC  on which remittance is sent".localized
            selfAwardTransactionTypeTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            selfAwardTransactionTypeTextView.inputTextFieldInputPickerView = self.getItemPickerView()
            selfAwardTransactionTypeTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    @IBOutlet private weak var ibanTextView: LabelledTextview! {
        didSet {
            ibanTextView.titleLabelText = "Beneficiary Account Number/ IBAN".localized
            ibanTextView.placeholderText = "xxxxxxxxxxxxx".localized
            ibanTextView.editTextKeyboardType = .default
            ibanTextView.inputFieldMinLength = 1
            ibanTextView.inputFieldMaxLength = 24
            ibanTextView.isEditable = true
            ibanTextView.formatValidator = FormatValidator(regex: RegexConstants.ibanRegex, invalidFormatError: "Please enter a valid Account Number/IBAN".localized)
            ibanTextView.onTextFieldChanged = { [weak self] updatedText in
                self?.viewModel.iban = updatedText
            }
            ibanTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    
    // - Unable to Self Award
    @IBOutlet private weak var selfAwardCnicTextView: LabelledTextview! {
        didSet {
            selfAwardCnicTextView.titleLabelText = "Beneficiary CNIC".localized
            selfAwardCnicTextView.placeholderText = "xxxxx-xxxxxxx-x".localized
            selfAwardCnicTextView.editTextKeyboardType = .asciiCapableNumberPad
            selfAwardCnicTextView.inputFieldMinLength = 13
            selfAwardCnicTextView.inputFieldMaxLength = 13
            selfAwardCnicTextView.formatValidator = CNICFormatValidator(regex: RegexConstants.cnicRegex, invalidFormatError: StringConstants.ErrorString.cnicError.localized)
            selfAwardCnicTextView.formatter = CNICFormatter()
            selfAwardCnicTextView.onTextFieldChanged = { [weak self] updatedText in
                self?.viewModel.cnic = updatedText
            }
        }
    }
    
    @IBOutlet weak var passportNumberTextView: LabelledTextview! {
        didSet {
            passportNumberTextView.titleLabelText = "Passport No. *".localized
            passportNumberTextView.placeholderText = "Enter Passport No.".localized
            passportNumberTextView.showHelpBtn = true
            passportNumberTextView.helpLabelText = "Please enter your passport number".localized
            passportNumberTextView.inputFieldMinLength = 3
            passportNumberTextView.inputFieldMaxLength = 20
            passportNumberTextView.editTextKeyboardType = .default
            passportNumberTextView.formatValidator = FormatValidator(regex: RegexConstants.passportRegex, invalidFormatError: StringConstants.ErrorString.passportNumberError.localized)
                passportNumberTextView.onTextFieldChanged = { [weak self] updatedText in
                    self?.viewModel.passport = updatedText
                }
            passportNumberTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
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
    @IBOutlet private weak var beneficaryAccountTextView: LabelledTextview! {
        didSet {
            beneficaryAccountTextView.titleLabelText = "Beneficiary Account Number/ IBAN/CNIC".localized
            beneficaryAccountTextView.placeholderText = "xxxxxxxxxxxxx".localized
            beneficaryAccountTextView.editTextKeyboardType = .default
            beneficaryAccountTextView.inputFieldMinLength = 1
            beneficaryAccountTextView.isEditable = true
            beneficaryAccountTextView.formatValidator = FormatValidator(regex: RegexConstants.alphanuericRegex, invalidFormatError: "Please enter a valid Beneficiary Account Number/ IBAN/CNIC")
            beneficaryAccountTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.beneficiaryCnic = updatedText
            }
        }
    }
    @IBOutlet weak var remittanceEntityTextView: LabelledTextview! {
        didSet {
            remittanceEntityTextView.titleLabelText = "Receiving Entity (Banks & Exchange Company)".localized
            remittanceEntityTextView.autoCapitalizationType = .words
            remittanceEntityTextView.editTextKeyboardType = .asciiCapable
            remittanceEntityTextView.showHelpBtn = true
            remittanceEntityTextView.helpLabelText = "Please mention the Bank and Exchange Company where the remittance was sent.".localized
            remittanceEntityTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.remittanceEntity = updatedText
            }
            remittanceEntityTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    @IBOutlet private weak var transactionIDTextView: LabelledTextview! {
        didSet {
            transactionIDTextView.titleLabelText = "Transaction ID".localized
            transactionIDTextView.placeholderText = "xxxxxxxxxxxxxx"
            transactionIDTextView.inputFieldMaxLength = 25
            transactionIDTextView.inputFieldMinLength = 5
            transactionIDTextView.editTextKeyboardType = .asciiCapable
            transactionIDTextView.formatValidator = FormatValidator(regex: RegexConstants.referenceNumberRegex, invalidFormatError: StringConstants.ErrorString.referenceNumberError.localized)
            transactionIDTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.transactionID = updatedText
            }
        }
    }
    @IBOutlet weak var transactionDateTextView: LabelledTextview! {
        didSet {
            transactionDateTextView.titleLabelText = "Transaction Date".localized
            transactionDateTextView.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            transactionDateTextView.placeholderText = "YYYY-MM-DD".localized
            transactionDateTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            transactionDateTextView.inputTextFieldInputPickerView = transactionDatePicker
        }
    }
    @IBOutlet private weak var transactionAmountLabelTextView: LabelledTextview! {
        didSet {
            transactionAmountLabelTextView.editTextKeyboardType = .decimalPad
            transactionAmountLabelTextView.titleLabel.numberOfLines = 0
            transactionAmountLabelTextView.titleLabelText = "Transaction Amount (PKR)".localized
            transactionAmountLabelTextView.placeholderText = "xx,xxx".localized
            transactionAmountLabelTextView.leadingText = "PKR ".localized
            transactionAmountLabelTextView.inputFieldMaxLength = 13
            transactionAmountLabelTextView.formatValidator = FormatValidator(regex: RegexConstants.transactionAmointDecimalRegex, invalidFormatError: StringConstants.ErrorString.transactionAmountError.localized)
            transactionAmountLabelTextView.formatter = CurrencyFormatter()
            transactionAmountLabelTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.transactionAmount = updatedText
            }
        }
    }
    @IBOutlet private weak var specifyDetailsTextArea: LabelledTextArea! {
        didSet {
            specifyDetailsTextArea.titleLabelText = "Specify Details".localized
            specifyDetailsTextArea.inputTextAreaMaxLength = 300
            specifyDetailsTextArea.formatValidator = FormatValidator(
                regex: RegexConstants.minFifteenCharacters,
                invalidFormatError: "Please use at least 15 characters to describe the problem in detail.".localized
            )
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
                redemptionIssueTextView.inputTextFieldInputPickerView = self.getItemPickerView()
            case .showActivityIndicator(show: let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .updateRedemptionPartner(let partner):
                redemptionIssueTextView.inputText = partner.title
                updateRedemptionFields(for: partner)
            case .showTransactionTypes:
                transactionTypesTextView.inputTextFieldInputPickerView = transactionTypesItemPickerView
            case .updateTransactionType(type: let type):
                transactionTypesTextView.inputText = type
            case .updateTransactionDate(dateStr: let dateStr):
                transactionDateTextView.inputText = dateStr
            case .updateSelfAwardTransactionType(type: let type):
                updateSelfAwardFields(with: type)
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
            // beneficaryAccountTextView.isHidden = false
            selfAwardTransactionTypeTextView.isHidden = false
            //            ibanTextView.isHidden = false
            //            selfAwardCnicTextView.isHidden = false
            //            passportNumberTextView.isHidden = false
            remittanceEntityTextView.isHidden = false
            transactionIDTextView.isHidden = false
            transactionDateTextView.isHidden = false
            transactionAmountLabelTextView.isHidden = false
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
            mobileOperatorTextView.isHidden = false
            transactionTypesTextView.isHidden = false
        case .redemptionIssues:
            redemptionIssueTextView.isHidden = false
            specifyDetailsTextArea.isHidden = false
        case .others:
            specifyDetailsTextArea.isHidden = false
        default:
            hideAllTextFields()
        }
    }
    
    private func updateRedemptionFields(for partner: RedemptionPartnerPickerItemModel) {
        // based on key
        if partner.key == "25" {
            branchTextView.isHidden = false
        } else {
            branchTextView.isHidden = true
        }
    }
    
    private func updateSelfAwardFields(with type: TransactionType?) {
        guard let type = type else {
            showAlert(with: .unknown)
            return
        }
        selfAwardTransactionTypeTextView.inputText = type.getTitle()
        
        switch type {
        case .cnic:
            ibanTextView.isHidden = true
            selfAwardCnicTextView.isHidden = false
            passportNumberTextView.isHidden = true
        case .bank:
            ibanTextView.isHidden = false
            selfAwardCnicTextView.isHidden = true
            passportNumberTextView.isHidden = true
        case .passport:
            
            ibanTextView.isHidden = true
            selfAwardCnicTextView.isHidden = true
            passportNumberTextView.isHidden = false
        }
        
    }
    
    private func getItemPickerView() -> ItemPickerView {
        var pickerView = ItemPickerView()
        pickerView.toolbarDelegate = self
        pickerView.viewModel = viewModel.partnerPickerViewModel
        return pickerView
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
        branchTextView.isHidden = true
        transactionTypesTextView.isHidden = true
        beneficiaryCnicTextView.isHidden = true
        beneficiaryCountryTextView.isHidden = true
        beneficiaryMobileNumberTextView.isHidden = true
        beneficiaryMobileOperatorTextView.isHidden = true
        beneficaryAccountTextView.isHidden = true
        remittanceEntityTextView.isHidden = true
        transactionIDTextView.isHidden = true
        transactionDateTextView.isHidden = true
        transactionAmountLabelTextView.isHidden = true
        specifyDetailsTextArea.isHidden = true
        selfAwardTransactionTypeTextView.isHidden = true
        ibanTextView.isHidden = true
        selfAwardCnicTextView.isHidden = true
        passportNumberTextView.isHidden = true
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
        case .beneficiaryAccount:
            beneficaryAccountTextView.updateStateTo(isError: state, error: message)
        case .remittingEntity:
            remittanceEntityTextView.updateStateTo(isError: state, error: message)
        case .transactionID:
            transactionIDTextView.updateStateTo(isError: state, error: message)
        case .transactionDate:
            transactionDateTextView.updateStateTo(isError: state, error: message)
        case .transactionAmount:
            transactionAmountLabelTextView.updateStateTo(isError: state, error: message)
        case .redemptionIssue:
            redemptionIssueTextView.updateStateTo(isError: state, error: message)
        case .selfAwardTransactionType:
            selfAwardTransactionTypeTextView.updateStateTo(isError: state, error: message)
        case .iban:
            ibanTextView.updateStateTo(isError: state, error: message)
        case .selfAwardCnic:
            selfAwardCnicTextView.updateStateTo(isError: state, error: message)
        case .passport:
            passportNumberTextView.updateStateTo(isError: state, error: message)
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
        case .beneficiaryAccount:
            beneficaryAccountTextView.becomeFirstResponder()
        case .remittingEntity:
            remittanceEntityTextView.becomeFirstResponder()
        case .transactionID:
            transactionIDTextView.becomeFirstResponder()
        case .transactionDate:
            transactionDateTextView.becomeFirstResponder()
        case .transactionAmount:
            transactionAmountLabelTextView.becomeFirstResponder()
        case .redemptionIssue:
            redemptionIssueTextView.becomeFirstResponder()
        case .selfAwardTransactionType:
            // selfAwardTransactionTypeTextView.becomeFirstResponder()
            break
        case .selfAwardCnic:
            selfAwardCnicTextView.becomeFirstResponder()
        case .iban:
            ibanTextView.becomeFirstResponder()
        case .passport:
            passportNumberTextView.becomeFirstResponder()
        }
    }
}

// MARK: Extension - ItemPickerViewDelegate

extension ComplaintFormViewController: ItemPickerViewDelegate, CustomDatePickerViewDelegate {
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
        
        if let item = selectedItem as? TransactionTypePickerItemModel {
            viewModel.didSelectSelfAwardTransactionType(type: item)
        }
        self.view.endEditing(true)
    }
    
    func didTapDoneButton(picker: CustomDatePickerView, date: Date) {
        self.view.endEditing(true)
        switch picker {
        case self.transactionDatePicker:
            viewModel.transactionDate = date
        default:
            break
        }
    }
}

// MARK: Extension - Initializable

extension ComplaintFormViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.complaintForm
    }
}

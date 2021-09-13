//
//  RegistrationViewController.swift
//  1Link-NRLP
//
//  Created by VenD on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class RegistrationViewController: BaseViewController {

    var viewModel: RegistrationViewModelProtocol!

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scrollViewBottomConstraint: NSLayoutConstraint!
    private lazy var itemPickerView: ItemPickerView! = {
        var pickerView = ItemPickerView()
        pickerView.toolbarDelegate = self
        pickerView.viewModel = viewModel.accountTypePickerViewModel
        return pickerView
    }()
    
    private lazy var passportItemPickerView: ItemPickerView! = {
        var pickerView = ItemPickerView()
        pickerView.toolbarDelegate = self
        pickerView.viewModel = viewModel.passportTypePickerViewModel
        return pickerView
    }()
    
    @IBOutlet private weak var progressBarView: ProgressBarView! {
        didSet {
            progressBarView.completedPercentage = 0.25
        }
    }
    @IBOutlet private weak var registrationCTAButton: PrimaryCTAButton! {
        didSet {
            registrationCTAButton.setTitle("Next".localized, for: .normal)
        }
    }
    @IBOutlet private weak var fullNameTextView: LabelledTextview! {
        didSet {
            fullNameTextView.titleLabelText = "Full Name *".localized
            fullNameTextView.placeholderText = "Muhammad Ali".localized
            fullNameTextView.autoCapitalizationType = .words
            fullNameTextView.inputFieldMaxLength = 50
            fullNameTextView.showHelpBtn = true
            fullNameTextView.helpLabelText = "Please enter your Full Name as per CNIC/NICOP".localized
            fullNameTextView.editTextKeyboardType = .asciiCapable
            fullNameTextView.formatValidator = FormatValidator(regex: RegexConstants.nameRegex, invalidFormatError: StringConstants.ErrorString.nameError.localized)
            fullNameTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.name = updatedText
            }
            fullNameTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    @IBOutlet private weak var cnicTextView: LabelledTextview! {
        didSet {
            cnicTextView.titleLabelText = "CNIC/NICOP *".localized
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
    @IBOutlet private weak var residentIDTextView: LabelledTextview! {
        didSet {
            residentIDTextView.titleLabelText = "Unique ID *".localized
            residentIDTextView.placeholderText = "Unique ID".localized
            residentIDTextView.showHelpBtn = true
            residentIDTextView.helpLabelText = "Please enter the unique ID you use for sending remittance to Pakistan through your bank or Money Transfer agent, including any  ID provided by your country of residence (Iqama No, Registration No., Emirati ID, Driving License, etc.)  ".localized
            residentIDTextView.editTextKeyboardType = .asciiCapableNumberPad
            residentIDTextView.inputFieldMinLength = 1
            residentIDTextView.inputFieldMaxLength = 25
            residentIDTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.residentID = updatedText
            }
            residentIDTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    
    @IBOutlet weak var passportTypeTextView: LabelledTextview! {
        didSet {
            passportTypeTextView.titleLabelText = "Passport Type *".localized
            passportTypeTextView.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            passportTypeTextView.placeholderText = "Select Passport Type".localized
            passportTypeTextView.showHelpBtn = true
            passportTypeTextView.helpLabelText = "Please select your passport type".localized
            passportTypeTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            passportTypeTextView.inputTextFieldInputPickerView = passportItemPickerView
            passportTypeTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    
    @IBOutlet weak var passportNumberTextView: LabelledTextview! {
        didSet {
            passportNumberTextView.titleLabelText = "Enter Passport Number *".localized
            passportNumberTextView.placeholderText = "Passport Number".localized
            passportNumberTextView.showHelpBtn = true
            passportNumberTextView.helpLabelText = "Please enter your passport number".localized
//            passportNumberTextView.textViewDescription = StringConstants.ErrorString.passportNumberError.localized
            passportNumberTextView.inputFieldMinLength = 3
            passportNumberTextView.inputFieldMaxLength = 20
            passportNumberTextView.editTextKeyboardType = .default
            passportNumberTextView.formatValidator = FormatValidator(regex: RegexConstants.passportRegex, invalidFormatError: StringConstants.ErrorString.passportNumberError.localized)
            passportNumberTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.passportNumber = updatedText
            }
            self.passportNumberTextView.isHidden = true
            passportNumberTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    
    @IBOutlet private weak var countryTextView: LabelledTextview! {
        didSet {
            countryTextView.titleLabelText = "Country of Residence *".localized
            countryTextView.placeholderText = "Select Country".localized
            countryTextView.isEditable = false
            countryTextView.isTappable = true
            countryTextView.showHelpBtn = true
            countryTextView.helpLabelText = "Please select your Residence Country".localized
            countryTextView.editTextKeyboardType = .asciiCapable
            countryTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            countryTextView.onTextFieldTapped = { [weak self] in
                guard let self = self else { return }
                self.viewModel.countryTextFieldTapped()
            }
            countryTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    @IBOutlet private weak var mobileNumberTextView: LabelledTextview! {
        didSet {
            mobileNumberTextView.titleLabelText = "Mobile Number *".localized
            mobileNumberTextView.placeholderText = "+xx xxx xxx xxxx".localized
            mobileNumberTextView.editTextKeyboardType = .asciiCapableNumberPad
            mobileNumberTextView.showHelpBtn = true
            mobileNumberTextView.helpLabelText = "Please enter your Mobile Number ".localized
            mobileNumberTextView.isEditable = false
            mobileNumberTextView.formatValidator = FormatValidator(regex: RegexConstants.mobileNumberRegex, invalidFormatError: StringConstants.ErrorString.mobileNumberError.localized)
            mobileNumberTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.mobileNumber = updatedText
            }
            mobileNumberTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
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
    @IBOutlet private weak var passwordTextView: LabelledTextview! {
        didSet {
            passwordTextView.titleLabelText = "Password *".localized
            passwordTextView.placeholderText = "Password@123".localized
            passwordTextView.showHelpBtn = true
            passwordTextView.helpLabelText = "Please enter a Password".localized
            passwordTextView.secureEntry = true
            passwordTextView.isPasswordField = true
            passwordTextView.textViewDescription = StringConstants.ErrorString.createPaasswordError.localized
            passwordTextView.editTextKeyboardType = .asciiCapable
            passwordTextView.formatValidator = FormatValidator(regex: RegexConstants.paasswordRegex, invalidFormatError: StringConstants.ErrorString.createPaasswordError.localized)
            passwordTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.paassword = updatedText
            }
            passwordTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    @IBOutlet private weak var reEnterPasswordTextView: LabelledTextview! {
        didSet {
            reEnterPasswordTextView.titleLabelText = "Re-Enter Password *".localized
            reEnterPasswordTextView.placeholderText = "Password@123".localized
            reEnterPasswordTextView.showHelpBtn = true
            reEnterPasswordTextView.helpLabelText = "Please re-enter the Password".localized
            reEnterPasswordTextView.secureEntry = true
            reEnterPasswordTextView.isPasswordField = true
            reEnterPasswordTextView.formatValidator = FormatValidator(regex: RegexConstants.paasswordRegex, invalidFormatError: StringConstants.ErrorString.reEnterPaasswordError.localized)
            reEnterPasswordTextView.editTextKeyboardType = .asciiCapable
            reEnterPasswordTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.rePaassword = updatedText
            }
            reEnterPasswordTextView.onTextFieldFocusChange = { [weak self] password in
                guard let self = self else { return }
                self.viewModel.didReEnteredPassword(rePaassword: password ?? "")
            }
            reEnterPasswordTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    @IBOutlet private weak var accountTypeTextView: LabelledTextview! {
        didSet {
            accountTypeTextView.titleLabelText = "User Type *".localized
            accountTypeTextView.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            accountTypeTextView.showHelpBtn = true
            accountTypeTextView.helpLabelText = "Please select if you are a Remitter (Sender) Or Beneficiary (Receiver) of remittance funds".localized
            accountTypeTextView.placeholderText = "Select User Type".localized
            accountTypeTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            accountTypeTextView.inputTextFieldInputPickerView = itemPickerView
            accountTypeTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModelOutput()
        setupKeyboardNotification()
    }
}

// MARK: Setup View and Bindings
extension RegistrationViewController {
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .showError(let error):
                self.showAlert(with: error)
            case .nextButtonState(let enableState):
                self.registrationCTAButton.isEnabled = enableState
            case .nameTextField(let errorState, let errorMsg):
                self.fullNameTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .cnicTextField(let errorState, let errorMsg):
                self.cnicTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .residentTextField(errorState: let errorState, error: let errorMsg):
                self.residentIDTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .countryTextField(let errorState, let errorMsg):
                self.countryTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .mobileNumberTextField(let errorState, let errorMsg):
                self.mobileNumberTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .emailTextField(let errorState, let errorMsg):
                self.emailAddressTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .passwordTextField(let errorState, let errorMsg):
                self.passwordTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .rePasswordTextField(let errorState, let errorMsg):
                self.reEnterPasswordTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .accountTypeTextField(let errorState, let errorMsg):
                self.accountTypeTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .passportTypeTextField(errorState: let errorState, error: let errorMsg):
                self.passportTypeTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .showPassportNumberField(isVisible: let isVisible):
                self.passportNumberTextView.isHidden = !isVisible
                self.passportNumberTextView.inputText = ""
            case .updateCountry(let name):
                self.countryTextView.inputText = name
            case .updateAccountType(let accountType):
                self.accountTypeTextView.inputText = accountType
            case .updatePassportType(passportType: let passportType):
                self.passportTypeTextView.inputText = passportType
            case .updateMobileCode(let code, let numberLength):
                self.mobileNumberTextView.leadingText = code
                self.mobileNumberTextView.inputFieldMinLength = numberLength
                self.mobileNumberTextView.inputFieldMaxLength = numberLength
                self.mobileNumberTextView.isEditable = true
                self.mobileNumberTextView.inputText = ""
                self.mobileNumberTextView.becomeFirstResponder()
            case .updateMobilePlaceholder(let placeholder):
                self.mobileNumberTextView.placeholderText = placeholder
            case .updateProgressBar(let toProgress):
                self.progressBarView.completedPercentage = toProgress
            case .focusField(let field):
                self.focus(field: field)
            case .passportNumberTextField(errorState: let errorState, error: let errorMsg):
                self.passportNumberTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .showNewFields(isRemitter: let isRemitter):
                if isRemitter {
                    residentIDTextView.isHidden = false
                    passportTypeTextView.isHidden = false
                    passportNumberTextView.isHidden = false
                } else {
                    residentIDTextView.isHidden = true
                    passportTypeTextView.isHidden = true
                    passportNumberTextView.isHidden = true
                }
            case .showRemitterPopup(viewModel: let viewModel):
                self.showAlert(with: viewModel)
            }
        }
    }
    
    private func focus(field: RegistrationViewModel.RegistrationFormInputFieldType) {
        switch field {
        case .fullName:
            fullNameTextView.becomeFirstResponder()
        case .cnic:
            cnicTextView.becomeFirstResponder()
        case .residentID:
            residentIDTextView.becomeFirstResponder()
        case .mobile:
            mobileNumberTextView.becomeFirstResponder()
        case .email:
            emailAddressTextView.becomeFirstResponder()
        case .password:
            passwordTextView.becomeFirstResponder()
        case .rePassword:
            reEnterPasswordTextView.becomeFirstResponder()
        case .passportNumber:
            passportNumberTextView.becomeFirstResponder()
        }
    }

    private func setupView() {
        self.title = "Register an account".localized
    }

    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollViewBottomConstraint.constant = keyboardSize.height
        }
    }

    @objc
    private func keyboardWillHide(sender: NSNotification) {
        scrollViewBottomConstraint.constant = 16
    }
}

// MARK: Button Actions
extension RegistrationViewController {
    @IBAction
    private func didTapNextButton(_ sender: Any) {
        viewModel.nextButtonPressed()
    }
}

extension RegistrationViewController: ItemPickerViewDelegate {
    func didTapCancelButton() {
        self.view.endEditing(true)
    }

    func didTapDoneButton(with selectedItem: PickerItemModel?) {
        if let item = selectedItem as? PassportTypePickerItemModel {
            viewModel.didSelectPassportType(passportType: item)
        } else {
            viewModel.didSelect(accountType: selectedItem as? AccountTypePickerItemModel)
        }
        self.view.endEditing(true)
    }
}

extension RegistrationViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.registration
    }
}

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
    private lazy var cnicIssueDatePicker: CustomDatePickerView = {
        var pickerView = CustomDatePickerView()
        pickerView.toolbarDelegate = self
        pickerView.isRegistration = true
        pickerView.viewModel = viewModel.datePickerViewModel
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
    @IBOutlet private weak var fatherNameTextView: LabelledTextview! {
        didSet {
            fatherNameTextView.titleLabelText = "Father Name *".localized
            fatherNameTextView.placeholderText = "Muhammad Ali".localized
            fatherNameTextView.autoCapitalizationType = .words
            fatherNameTextView.inputFieldMaxLength = 50
            fatherNameTextView.showHelpBtn = true
            fatherNameTextView.helpLabelText = "Please enter your Father Name as per CNIC/NICOP".localized
            fatherNameTextView.editTextKeyboardType = .asciiCapable
            fatherNameTextView.formatValidator = FormatValidator(regex: RegexConstants.nameRegex, invalidFormatError: StringConstants.ErrorString.nameError.localized)
            fatherNameTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.fatherName = updatedText
            }
            fatherNameTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    @IBOutlet private weak var motherNameTextView: LabelledTextview! {
        didSet {
            motherNameTextView.titleLabelText = "Mother Maiden Name *".localized
            motherNameTextView.placeholderText = "Kaneez Fatima".localized
            motherNameTextView.autoCapitalizationType = .words
            motherNameTextView.inputFieldMaxLength = 50
            motherNameTextView.showHelpBtn = false
            motherNameTextView.helpLabelText = "Please enter your Full Name as per CNIC/NICOP".localized
            motherNameTextView.editTextKeyboardType = .asciiCapable
            motherNameTextView.formatValidator = FormatValidator(regex: RegexConstants.nameRegex, invalidFormatError: StringConstants.ErrorString.nameError.localized)
            motherNameTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.motherMaidenName = updatedText
            }
            motherNameTextView.onHelpBtnPressed = { [weak self] model in
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
    
    @IBOutlet private weak var cnicIssueDateTextView: LabelledTextview! {
        didSet {
            cnicIssueDateTextView.titleLabelText = "CNIC/NICOP Issuance Date *".localized
            cnicIssueDateTextView.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            cnicIssueDateTextView.showHelpBtn = false
            cnicIssueDateTextView.helpLabelText = "Please enter your CNIC/NICOP issue date".localized
            cnicIssueDateTextView.placeholderText = "Select CNIC/NICOP Issue Date".localized
            cnicIssueDateTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            cnicIssueDateTextView.inputTextFieldInputPickerView = cnicIssueDatePicker
            cnicIssueDateTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    
    @IBOutlet private weak var birthPlaceTextView: LabelledTextview! {
        didSet {
            birthPlaceTextView.titleLabelText = "Place of Birth *".localized
            birthPlaceTextView.placeholderText = "Islamabad".localized
            birthPlaceTextView.autoCapitalizationType = .words
            birthPlaceTextView.inputFieldMaxLength = 50
            birthPlaceTextView.showHelpBtn = false
            birthPlaceTextView.helpLabelText = "Please select your place of birth".localized // change select to enter
            birthPlaceTextView.editTextKeyboardType = .asciiCapable
            birthPlaceTextView.formatValidator = FormatValidator(regex: RegexConstants.nameRegex, invalidFormatError: StringConstants.ErrorString.nameError.localized)
            birthPlaceTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.birthPlace = updatedText
            }
            birthPlaceTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    
    @IBOutlet private weak var residentIDTextView: LabelledTextview! {
        didSet {
            residentIDTextView.titleLabelText = "Unique ID *".localized
            residentIDTextView.placeholderText = "Unique ID".localized
            residentIDTextView.showHelpBtn = true
            residentIDTextView.helpLabelText = "Please enter the unique ID you use for sending remittance to Pakistan through your bank or Money Transfer agent, including any  ID provided by your country of residence (Iqama No, Registration No., Emirati ID, Driving License, etc.)".localized
            residentIDTextView.editTextKeyboardType = .default
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
            mobileNumberTextView.helpLabelText = "Please enter your Mobile Number".localized
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

    @IBOutlet private weak var codeTextView: CodeLabelledTextView! {
        didSet {
            codeTextView.titleLabelText = "Registration Code *".localized
            codeTextView.showHelpBtn = false
            codeTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.beneficaryOTP = updatedText ?? ""
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
                self.mobileNumberTextView.inputFieldMinLength = 1
//                self.mobileNumberTextView.inputFieldMaxLength = numberLength
                self.mobileNumberTextView.isEditable = true
                self.mobileNumberTextView.inputText = ""
                self.mobileNumberTextView.becomeFirstResponder()
            case .updateMobilePlaceholder(let placeholder):
                self.mobileNumberTextView.placeholderText = placeholder
            case .updateProgressBar(let toProgress):
                self.progressBarView.completedPercentage = toProgress
            case .focusField(let field):
                self.focus(field: field)
            case .showNewFields(isRemitter: let isRemitter):
                if isRemitter {
                    residentIDTextView.isHidden = false
                    passportTypeTextView.isHidden = false
                    passportNumberTextView.isHidden = false
                    fullNameTextView.isHidden = false
                    fatherNameTextView.isHidden = false
                    motherNameTextView.isHidden = false
                    birthPlaceTextView.isHidden = false
                    countryTextView.isHidden = false
                    cnicTextView.isHidden = false
                    cnicIssueDateTextView.isHidden = false
                    mobileNumberTextView.isHidden = false
                    emailAddressTextView.isHidden = false
                    passwordTextView.isHidden = false
                    reEnterPasswordTextView.isHidden = false
                    codeTextView.isHidden = true
                } else {
                    residentIDTextView.isHidden = true
                    passportTypeTextView.isHidden = true
                    passportNumberTextView.isHidden = true
                    fullNameTextView.isHidden = true
                    fatherNameTextView.isHidden = true
                    motherNameTextView.isHidden = true
                    birthPlaceTextView.isHidden = true
                    countryTextView.isHidden = true
                    cnicTextView.isHidden = false
                    cnicIssueDateTextView.isHidden = true
                    mobileNumberTextView.isHidden = true
                    emailAddressTextView.isHidden = true
                    passwordTextView.isHidden = true
                    reEnterPasswordTextView.isHidden = true
                    codeTextView.isHidden = false
                }
            case .showRemitterPopup(viewModel: _):
                ()
//                self.showAlert(with: viewModel)
            case .updateCnicIssueDate(dateStr: let dateStr):
                self.cnicIssueDateTextView.inputText = dateStr
            case .textField(errorState: let errorState, error: let error, textfieldType: let type):
                self.setTextFieldErrorState(state: errorState, message: error, textfield: type)
            case .updateBirthPlace(name: let name):
                self.birthPlaceTextView.inputText = name
            case .showActivityIndicator(show: let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
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
        case .mobileNumber:
            mobileNumberTextView.becomeFirstResponder()
        case .emailAddress:
            emailAddressTextView.becomeFirstResponder()
        case .password:
            passwordTextView.becomeFirstResponder()
        case .confirmPassword:
            reEnterPasswordTextView.becomeFirstResponder()
        case .passportNumber:
            passportNumberTextView.becomeFirstResponder()
        case .userType:
            accountTypeTextView.becomeFirstResponder()
        case .motherName:
            motherNameTextView.becomeFirstResponder()
        case .birthPlace:
            birthPlaceTextView.becomeFirstResponder()
        case .countryOfResidence:
            countryTextView.becomeFirstResponder()
        case .cnicIssueDate:
            cnicIssueDateTextView.becomeFirstResponder()
        case .passportType:
            passportTypeTextView.becomeFirstResponder()
        case .beneficiaryOtp:
            codeTextView.becomeFirstResponder()
        case .fatherName:
            fatherNameTextView.becomeFirstResponder()
        }
    }

    private func setTextFieldErrorState(state: Bool, message: String?, textfield: RegistrationViewModel.RegistrationFormInputFieldType) {
        switch textfield {
        case .userType:
            self.accountTypeTextView.updateStateTo(isError: state, error: message)
        case .fullName:
            self.fullNameTextView.updateStateTo(isError: state, error: message)
        case .motherName:
            self.motherNameTextView.updateStateTo(isError: state, error: message)
        case .birthPlace:
            self.birthPlaceTextView.updateStateTo(isError: state, error: message)
        case .countryOfResidence:
            self.countryTextView.updateStateTo(isError: state, error: message)
        case .cnic:
            self.cnicTextView.updateStateTo(isError: state, error: message)
        case .cnicIssueDate:
            self.cnicIssueDateTextView.updateStateTo(isError: state, error: message)
        case .passportType:
            self.passportTypeTextView.updateStateTo(isError: state, error: message)
        case .passportNumber:
            self.passportNumberTextView.updateStateTo(isError: state, error: message)
        case .residentID:
            self.residentIDTextView.updateStateTo(isError: state, error: message)
        case .mobileNumber:
            self.mobileNumberTextView.updateStateTo(isError: state, error: message)
        case .emailAddress:
            self.emailAddressTextView.updateStateTo(isError: state, error: message)
        case .password:
            self.passwordTextView.updateStateTo(isError: state, error: message)
        case .confirmPassword:
            self.reEnterPasswordTextView.updateStateTo(isError: state, error: message)
        case .beneficiaryOtp:
            self.codeTextView.updateStateTo(isError: state, error: message)
        case .fatherName:
            self.fatherNameTextView.updateStateTo(isError: state, error: message)
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

extension RegistrationViewController: CustomDatePickerViewDelegate {

    func didTapDoneButton(picker: CustomDatePickerView, date: Date) {
        self.view.endEditing(true)
        switch picker {
        case self.cnicIssueDatePicker:
            self.viewModel.cnicIssueDate = date
        default:
            break
        }
    }
}

extension RegistrationViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.registration
    }
}

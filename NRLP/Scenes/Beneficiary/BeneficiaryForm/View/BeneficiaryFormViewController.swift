//
//  BeneficiaryFormViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 23/12/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import UIKit

class BeneficiaryFormViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: BeneficiaryFormViewModelProtocol!
    
    private lazy var cnicIssueDatePicker: CustomDatePickerView = {
        var pickerView = CustomDatePickerView()
        pickerView.toolbarDelegate = self
        pickerView.isRegistration = true
        pickerView.viewModel = viewModel.datePickerViewModel
        return pickerView
    }()
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var progressBarView: ProgressBarView! {
        didSet {
            progressBarView.completedPercentage = 0.4
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
    
    @IBOutlet private weak var birthPlaceTextView: LabelledTextview! {
        didSet {
            birthPlaceTextView.titleLabelText = "Place of Birth *".localized
            birthPlaceTextView.placeholderText = "Select City".localized
            birthPlaceTextView.isEditable = false
            birthPlaceTextView.isTappable = true
            birthPlaceTextView.showHelpBtn = false
            birthPlaceTextView.helpLabelText = "Please select your place of birth".localized
            birthPlaceTextView.editTextKeyboardType = .asciiCapable
            birthPlaceTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            birthPlaceTextView.onTextFieldTapped = { [weak self] in
                guard let self = self else { return }
                self.viewModel.birthPlaceTextFieldTapped()
            }
            birthPlaceTextView.onHelpBtnPressed = { [weak self] model in
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
                self.viewModel.emailAddress = updatedText
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
                self.viewModel.password = updatedText
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
                self.viewModel.confirmPassword = updatedText
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
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModelOutput()
        setupKeyboardNotification()
    }
    
    // MARK: - Helper Methods
    
    private func setupView() {
        self.title = "Register an account".localized
    }
    
    // MARK: - IBActions
    
    @IBAction private func didTapNextButton(_ sender: Any) {
        viewModel.nextButtonPressed()
    }
}

extension BeneficiaryFormViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.beneficiaryForm
    }
}

extension BeneficiaryFormViewController: CustomDatePickerViewDelegate {
    func didTapCancelButton() {
        self.view.endEditing(true)
    }

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

extension BeneficiaryFormViewController {
    
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .showError(error: let error):
                self.showAlert(with: error)
            case .updateCountry(name: let name):
                self.countryTextView.inputText = name
            case .updateBirthPlace(name: let name):
                self.birthPlaceTextView.inputText = name
            case .updateMobileCode(code: let code, length: let numberLength):
                self.mobileNumberTextView.leadingText = code
                self.mobileNumberTextView.inputFieldMinLength = 1
//                self.mobileNumberTextView.inputFieldMaxLength = numberLength
                self.mobileNumberTextView.isEditable = true
                self.mobileNumberTextView.inputText = ""
                self.mobileNumberTextView.becomeFirstResponder()
            case .updateMobilePlaceholder(placeholder: let placeholder):
                self.mobileNumberTextView.placeholderText = placeholder
            case .nextButtonState(enableState: let enableState):
                self.registrationCTAButton.isEnabled = enableState
            case .textField(errorState: let errorState, error: let error, textfieldType: let textfieldType):
                self.setTextFieldErrorState(state: errorState, message: error, textfield: textfieldType)
            case .updateProgressBar(toProgress: let toProgress):
                self.progressBarView.completedPercentage = toProgress
            case .focusField(type: let type):
                self.focus(field: type)
            case .updateCnicIssueDate(dateStr: let dateStr):
                self.cnicIssueDateTextView.inputText = dateStr
            }
        }
    }
    
    private func focus(field: BeneficiaryFormViewModel.BeneficiaryFormInputFieldType) {
        switch field {
        
        case .fullName:
            self.fullNameTextView.becomeFirstResponder()
        case .birthPlace:
            self.birthPlaceTextView.becomeFirstResponder()
        case .countryOfResidence:
            self.countryTextView.becomeFirstResponder()
        case .cnicIssueDate:
            self.cnicIssueDateTextView.becomeFirstResponder()
        case .mobileNumber:
            self.mobileNumberTextView.becomeFirstResponder()
        case .emailAddress:
            self.emailAddressTextView.becomeFirstResponder()
        case .password:
            self.passwordTextView.becomeFirstResponder()
        case .confirmPassword:
            self.reEnterPasswordTextView.becomeFirstResponder()
        case .motherName:
            self.motherNameTextView.becomeFirstResponder()
        }
    }
    
    private func setTextFieldErrorState(state: Bool, message: String?, textfield: BeneficiaryFormViewModel.BeneficiaryFormInputFieldType) {
        switch textfield {
        
        case .fullName:
            self.fullNameTextView.updateStateTo(isError: state, error: message)
        case .birthPlace:
            self.birthPlaceTextView.updateStateTo(isError: state, error: message)
        case .countryOfResidence:
            self.countryTextView.updateStateTo(isError: state, error: message)
        case .cnicIssueDate:
            self.cnicIssueDateTextView.updateStateTo(isError: state, error: message)
        case .mobileNumber:
            self.mobileNumberTextView.updateStateTo(isError: state, error: message)
        case .emailAddress:
            self.emailAddressTextView.updateStateTo(isError: state, error: message)
        case .password:
            self.passwordTextView.updateStateTo(isError: state, error: message)
        case .confirmPassword:
            self.reEnterPasswordTextView.updateStateTo(isError: state, error: message)
        case .motherName:
            self.motherNameTextView.updateStateTo(isError: state, error: message)
        }
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

//
//  ProfileViewController.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 17/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    var viewModel: ProfileViewModelProtocol!
    var editingEnabled: Bool = false
    var isBeneficiary = false
    
    private lazy var passportItemPickerView: ItemPickerView! = {
        var pickerView = ItemPickerView()
        pickerView.toolbarDelegate = self
        pickerView.viewModel = viewModel.passportTypePickerViewModel
        return pickerView
    }()
    
    @IBOutlet weak var bottomCTAButtonStack: UIStackView!
    @IBOutlet private weak var fullNameTextView: LabelledTextview! {
        didSet {
            fullNameTextView.titleLabelText = "Full Name".localized
            fullNameTextView.placeholderText = "Muhammad Ali".localized
            fullNameTextView.inputFieldMaxLength = 50
            fullNameTextView.editTextKeyboardType = .asciiCapable
            fullNameTextView.autoCapitalizationType = .words
            fullNameTextView.isEditable = false
            fullNameTextView.formatValidator = FormatValidator(regex: RegexConstants.nameRegex, invalidFormatError: StringConstants.ErrorString.nameError.localized)
        }
    }
    
    @IBOutlet private weak var motherNameTextView: LabelledTextview! {
        didSet {
            motherNameTextView.titleLabelText = "Mother Maiden Name".localized
            motherNameTextView.placeholderText = "Kaneez Fatima".localized
            motherNameTextView.autoCapitalizationType = .words
            motherNameTextView.inputFieldMaxLength = 50
            motherNameTextView.isEditable = false
            motherNameTextView.editTextKeyboardType = .asciiCapable
            motherNameTextView.formatValidator = FormatValidator(regex: RegexConstants.nameRegex, invalidFormatError: StringConstants.ErrorString.nameError.localized)
        }
    }
    
    @IBOutlet private weak var birthPlaceTextView: LabelledTextview! {
        didSet {
            birthPlaceTextView.titleLabelText = "Place of Birth".localized
            birthPlaceTextView.placeholderText = "Select City".localized
            birthPlaceTextView.isEditable = false
            birthPlaceTextView.editTextKeyboardType = .asciiCapable
        }
    }
    
    @IBOutlet private weak var cnicTextView: LabelledTextview! {
        didSet {
            cnicTextView.titleLabelText = "CNIC/NICOP".localized
            cnicTextView.placeholderText = "xxxxx-xxxxxxx-x".localized
            cnicTextView.editTextKeyboardType = .asciiCapableNumberPad
            cnicTextView.formatter = CNICFormatter()
            cnicTextView.isEditable = false
            cnicTextView.formatValidator = FormatValidator(regex: RegexConstants.cnicRegex, invalidFormatError: StringConstants.ErrorString.cnicError.localized)
        }
    }
    
    @IBOutlet private weak var cnicIssueDateTextView: LabelledTextview! {
        didSet {
            cnicIssueDateTextView.titleLabelText = "CNIC/NICOP Issuance Date".localized
            cnicIssueDateTextView.placeholderText = "Select CNIC/NICOP Issue Date".localized
            cnicIssueDateTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            cnicIssueDateTextView.isEditable = false
        }
    }
    
    @IBOutlet private weak var residentIDTextView: LabelledTextview! {
        didSet {
            residentIDTextView.titleLabelText = "Unique ID".localized
            residentIDTextView.placeholderText = "Unique ID".localized
            residentIDTextView.editTextKeyboardType = .default
            residentIDTextView.inputFieldMinLength = 1
            residentIDTextView.inputFieldMaxLength = 25
            residentIDTextView.formatValidator = FormatValidator(regex: RegexConstants.residentId, invalidFormatError: "Invalid Unique ID")
            passportNumberTextView.isEditable = false
            residentIDTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.residentID = updatedText
            }
        }
    }
    
    @IBOutlet weak var passportTypeTextView: LabelledTextview! {
        didSet {
            passportTypeTextView.titleLabelText = "Passport Type".localized
            passportTypeTextView.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            passportTypeTextView.placeholderText = "Select Passport Type".localized
            passportTypeTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            passportTypeTextView.inputTextFieldInputPickerView = passportItemPickerView
            self.passportTypeTextView.isHidden = true
        }
    }
    
    @IBOutlet weak var passportNumberTextView: LabelledTextview! {
        didSet {
            passportNumberTextView.titleLabelText = "Passport Number".localized
            passportNumberTextView.placeholderText = "Passport Number".localized
//            passportNumberTextView.textViewDescription = StringConstants.ErrorString.passportNumberError.localized
            passportNumberTextView.inputFieldMinLength = 3
            passportNumberTextView.inputFieldMaxLength = 20
            passportNumberTextView.editTextKeyboardType = .default
            passportNumberTextView.formatValidator = FormatValidator(regex: RegexConstants.passportRegex, invalidFormatError: StringConstants.ErrorString.passportNumberError.localized)
            passportNumberTextView.isEditable = false
            passportNumberTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.passportNumber = updatedText
            }
//            self.passportNumberTextView.isHidden = true
        }
    }
    
    @IBOutlet private weak var emailTextView: LabelledTextview! {
        didSet {
            emailTextView.titleLabelText = "Email Address (Optional)".localized
            emailTextView.placeholderText = "abc@abc.com".localized
            emailTextView.editTextKeyboardType = .emailAddress
            emailTextView.isEditable = false
            emailTextView.formatValidator = FormatValidator(regex: RegexConstants.emailRegex, invalidFormatError: StringConstants.ErrorString.emailError.localized)
            emailTextView.onTextFieldChanged = { [weak self] updatedText in
                self?.viewModel.email = updatedText
            }
        }
    }
    
    @IBOutlet private weak var countryTextView: LabelledTextview! {
        didSet {
            countryTextView.titleLabelText = "Country of Residence".localized
            countryTextView.placeholderText = "Select Country".localized
            countryTextView.isTappable = false
            countryTextView.isEditable = false
            countryTextView.editTextKeyboardType = .default
            countryTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            countryTextView.onTextFieldTapped = { [weak self] in
                    self?.viewModel.countryTextFieldTapped()
            }
        }
    }
    
    @IBOutlet private weak var mobileTextView: LabelledTextview! {
        didSet {
            mobileTextView.titleLabelText = "Mobile Number".localized
            mobileTextView.placeholderText = "+xx xxx xxx xxxx".localized
            mobileTextView.editTextKeyboardType = .asciiCapableNumberPad
            mobileTextView.isEditable = false
            mobileTextView.formatValidator = FormatValidator(regex: RegexConstants.mobileNumberRegex, invalidFormatError: StringConstants.ErrorString.mobileNumberError.localized)
            mobileTextView.onTextFieldChanged = { [weak self] updatedText in
                self?.viewModel.mobileNumber = updatedText
            }
        }
    }
    
    @IBOutlet private weak var cancelButton: SecondaryCTAButton! {
        didSet {
            cancelButton.setTitle("Cancel".localized, for: .normal)
        }
    }
    
    @IBOutlet private weak var editButton: PrimaryCTAButton! {
        didSet {
            editButton.setTitle("Edit".localized, for: .normal)
        }
    }
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModelOutput()
        viewModel.viewDidLoad()
        setupKeyboardNotification()
    }
    
    func setupUI() {
        self.title = "Update Profile".localized
    }
    
    func resetEditing() {
        countryTextView.updateStateTo(isError: false, error: nil)
        mobileTextView.updateStateTo(isError: false, error: nil)
        emailTextView.updateStateTo(isError: false, error: nil)
        residentIDTextView.updateStateTo(isError: false, error: nil)
        passportTypeTextView.updateStateTo(isError: false, error: nil)
        passportNumberTextView.updateStateTo(isError: false, error: nil)
        enabledEditing(enable: false)
    }
    
    func enabledEditing(enable: Bool) {
        editingEnabled = enable
        emailTextView.isEditable = enable
        mobileTextView.isEditable = enable
        countryTextView.isEditable = enable
        if !isBeneficiary {
            passportTypeTextView.isEditable = enable
            passportNumberTextView.isEditable = enable
            residentIDTextView.isEditable = enable
            self.passportTypeTextView.isHidden = false
        }
        
        if enable {
            editButton.setTitle("Save".localized, for: .normal)
            editButton.isEnabled = false
            cancelButton.isHidden = false
            self.countryTextView.isTappable = true
        } else {
            editButton.setTitle("Edit".localized, for: .normal)
            editButton.isEnabled = true
            cancelButton.isHidden = true
            self.countryTextView.isTappable = false
        }
        
    }
    
    @IBAction func editButtonPressed(_ sender: PrimaryCTAButton) {
        if editingEnabled {
            viewModel.saveButtonPressed()
        } else {
            viewModel.editButtonPressed()
        }
    }
}

// MARK: Setup View and Bindings
extension ProfileViewController {
    func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .nameTextField(let errorState, let errorMsg):
                self.fullNameTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .cnicTextField(let errorState, let errorMsg):
                self.cnicTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .countryTextField(let errorState, let errorMsg):
                self.countryTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .mobileNumberTextField(let errorState, let errorMsg):
                self.mobileTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .emailTextField(let errorState, let errorMsg):
                self.emailTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .updateCountry(let country):
                self.countryTextView.inputText = country?.country
                self.countryTextView.inputFieldMaxLength = Int(country?.length ?? 0)
            case .updateMobileCode(let code, let numberLength):
                self.updateMobileCode(code: code, numberLength: numberLength)
                self.mobileTextView.becomeFirstResponder()
            case .updateMobilePlaceholder(let placeholder):
                self.mobileTextView.placeholderText = placeholder
            case .nextButtonState(let enableState):
                self.editButton.isEnabled = enableState
            case .editingEnabled:
                self.enabledEditing(enable: true)
            case .editingReset:
                self.passportTypeTextView.isHidden = true
                self.resetEditing()
            case .setUser(let user):
                self.setUser(user: user)
            case .showAlert(let alert):
                self.showAlert(with: alert)
            case .showActivityIndicator(let status):
                status ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                self.showAlert(with: error)
            case .setMobileNumber(let number):
                self.mobileTextView.inputText = number
            case .updatePassportType(passportType: let passportType):
                self.passportTypeTextView.inputText = passportType
                self.passportNumberTextView.inputText = ""
            case .passportNumberTextField(errorState: let errorState, error: let error):
                self.passportNumberTextView.updateStateTo(isError: errorState, error: error)
            case .passportTypeTextField(errorState: let errorState, error: let error):
                self.passportTypeTextView.updateStateTo(isError: errorState, error: error)
            case .residentIDTextField(errorState: let errorState, error: let error):
                self.residentIDTextView.updateStateTo(isError: errorState, error: error)
            case .setCountry(country: let country):
                self.countryTextView.inputText = country.country
            }
        }
    }
    
    func updateMobileCode(code: String, numberLength: Int) {
        mobileTextView.leadingText = code
//        self.mobileTextView.inputFieldMaxLength = numberLength
        self.mobileTextView.inputText = ""
    }
    
    func setUser(user: UserModel) {
        if user.type?.lowercased() == AccountType.beneficiary.rawValue.lowercased() {
            self.passportNumberTextView.isHidden = true
            self.passportTypeTextView.isHidden = true
            self.residentIDTextView.isHidden = true
            self.motherNameTextView.isHidden = true
            isBeneficiary = true
        }
        fullNameTextView.inputText = user.fullName
        cnicTextView.inputText = "\(user.cnicNicop)"
        emailTextView.inputText = user.email
        passportTypeTextView.inputText = user.passportType?.rawValue.capitalized
        passportNumberTextView.inputText = user.passportNumber
        residentIDTextView.inputText = user.residentID
        motherNameTextView.inputText = user.motherMaidenName
        birthPlaceTextView.inputText = user.birthPlace
        cnicIssueDateTextView.inputText = user.formattedCnicIssueDate
        
        if let email = user.email,
           email.isEmpty {
            emailTextView.placeholderText = ""
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: SecondaryCTAButton) {
        viewModel.cancelButtonPressed()
    }
    
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollViewBottomConstraint.constant = keyboardSize.height - bottomCTAButtonStack.frame.height - 16
        }
    }

    @objc
    private func keyboardWillHide(sender: NSNotification) {
        scrollViewBottomConstraint.constant = 16
    }
}

extension ProfileViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.profile
    }
}

extension ProfileViewController: ItemPickerViewDelegate {
    func didTapCancelButton() {
        self.view.endEditing(true)
    }
    
    func didTapDoneButton(with selectedItem: PickerItemModel?) {
        if let item = selectedItem as? PassportTypePickerItemModel {
            viewModel.didSelectPassportType(passportType: item)
        }
        self.view.endEditing(true)
    }
}

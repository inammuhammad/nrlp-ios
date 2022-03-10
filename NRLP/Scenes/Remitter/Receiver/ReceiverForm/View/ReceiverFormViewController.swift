//
//  ReceiverFormViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 21/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class ReceiverFormViewController: BaseViewController {

    // MARK: - Properties
    
    var viewModel: ReceiverFormViewModelProtocol!
    private lazy var cnicIssueDatePicker: CustomDatePickerView = {
        var pickerView = CustomDatePickerView()
        pickerView.toolbarDelegate = self
        pickerView.viewModel = viewModel.datePickerViewModel
        return pickerView
    }()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nextBtn: PrimaryCTAButton! {
        didSet {
            nextBtn.setTitle("Next".localized, for: .normal)
        }
    }
    
    @IBOutlet private weak var fullNameTextView: LabelledTextview! {
        didSet {
            fullNameTextView.titleLabelText = "Full Name *".localized
            fullNameTextView.placeholderText = "Please enter Receiver Information".localized
            fullNameTextView.autoCapitalizationType = .words
            fullNameTextView.inputFieldMaxLength = 50
            fullNameTextView.showHelpBtn = true
            fullNameTextView.helpLabelText = "Please enter Receiver Name as per CNIC/NICOP".localized
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
            motherNameTextView.placeholderText = "Please enter Receiver Information".localized
            motherNameTextView.autoCapitalizationType = .words
            motherNameTextView.inputFieldMaxLength = 50
            motherNameTextView.showHelpBtn = true
            motherNameTextView.helpLabelText = "Please enter Receiver Mother Name as per NADRA record".localized
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
            cnicTextView.placeholderText = "Please enter Receiver Information".localized
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
            cnicIssueDateTextView.placeholderText = "Please enter Receiver Information".localized
            cnicIssueDateTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            cnicIssueDateTextView.inputTextFieldInputPickerView = cnicIssueDatePicker
        }
    }
    
    @IBOutlet private weak var birthPlaceTextView: LabelledTextview! {
        didSet {
            birthPlaceTextView.titleLabelText = "Place of Birth *".localized
            birthPlaceTextView.placeholderText = "Please enter Receiver Information".localized
            birthPlaceTextView.isEditable = false
            birthPlaceTextView.isTappable = true
            birthPlaceTextView.showHelpBtn = true
            birthPlaceTextView.helpLabelText = "Please enter Receiver Place of Birth as per NADRA record".localized
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
            countryTextView.editTextKeyboardType = .asciiCapable
            countryTextView.editTextCursorColor = .init(white: 1, alpha: 0)
            countryTextView.onTextFieldTapped = { [weak self] in
                guard let self = self else { return }
                self.viewModel.countryTextFieldTapped()
            }
        }
    }
    
    @IBOutlet private weak var mobileNumberTextView: LabelledTextview! {
        didSet {
            mobileNumberTextView.titleLabelText = "Mobile Number *".localized
            mobileNumberTextView.placeholderText = "Please enter Receiver Information".localized
            mobileNumberTextView.editTextKeyboardType = .asciiCapableNumberPad
            mobileNumberTextView.formatValidator = FormatValidator(regex: RegexConstants.mobileNumberRegex, invalidFormatError: StringConstants.ErrorString.mobileNumberError.localized)
            mobileNumberTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.mobileNumber = updatedText
            }
        }
    }
    
    @IBOutlet private weak var bankNameTextView: LabelledTextview! {
        didSet {
            bankNameTextView.titleLabelText = "Bank Name *".localized
            bankNameTextView.placeholderText = "Please enter Receiver Information".localized
            bankNameTextView.editTextKeyboardType = .asciiCapableNumberPad
            bankNameTextView.isEditable = false
            bankNameTextView.isTappable = true
            bankNameTextView.showHelpBtn = true
            bankNameTextView.helpLabelText = "Please enter Receiver Bank Name".localized
//            bankNameTextView.onTextFieldChanged = { [weak self] updatedText in
//                guard let self = self else { return }
//                self.viewModel.bankName = updatedText
//            }
            bankNameTextView.onTextFieldTapped = { [weak self] in
                guard let self = self else { return }
                self.viewModel.bankTextFieldTapped()
            }
            bankNameTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    
    @IBOutlet private weak var bankNumberTextView: LabelledTextview! {
        didSet {
            bankNumberTextView.titleLabelText = "Bank Number / IBAN *".localized
            bankNumberTextView.placeholderText = "Please enter Receiver Information".localized
            bankNumberTextView.editTextKeyboardType = .asciiCapableNumberPad
            bankNumberTextView.showHelpBtn = true
            bankNumberTextView.helpLabelText = "Please enter Receiver Bank Account Number/IBAN".localized
            bankNumberTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.bankNumber = updatedText
            }
            bankNumberTextView.onHelpBtnPressed = { [weak self] model in
                guard let self = self else { return }
                self.showAlert(with: model)
            }
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        setupUI()
        bindViewModelOutput()
        viewModel.viewDidLoad()
        super.viewDidLoad()
    }
    
    // MARK: - Helper Methods
    
    private func setupUI() {
        self.title = "Remittance Receiver Management".localized
    }
    
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .showAlert(let alertViewModel):
                self.showAlert(with: alertViewModel)
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                self.showAlert(with: error)
            case .buttonState(enabled: let enabled):
                self.nextBtn.isEnabled = enabled
            case .updateCnicIssueDate(dateStr: let dateStr):
                self.cnicIssueDateTextView.inputText = dateStr
            case .updateBirthPlace(name: let name):
                self.birthPlaceTextView.inputText = name
            case .showBankFields(hidden: let hidden):
                self.bankNameTextView.isHidden = hidden
                self.bankNumberTextView.isHidden = hidden
            case .updateCountry(let name):
                self.countryTextView.inputText = name
            case .updateMobileCode(let code, _):
                self.mobileNumberTextView.leadingText = code
                self.mobileNumberTextView.inputFieldMinLength = 1
//                self.mobileNumberTextView.inputFieldMaxLength = numberLength
                self.mobileNumberTextView.isEditable = true
                self.mobileNumberTextView.inputText = ""
                self.mobileNumberTextView.becomeFirstResponder()
            case .updateMobilePlaceholder(let placeholder):
                self.mobileNumberTextView.placeholderText = placeholder
            case .textField(errorState: let errorState, error: let error, textfieldType: let textfieldType):
                setTextFieldErrorState(state: errorState, message: error, textfield: textfieldType)
            case .focusField(textField: let type):
                focusTextfield(textFieldType: type)
            case .updateBankName(name: let bankName):
                self.bankNameTextView.inputText = bankName
            }
        }
    }
    
    private func setTextFieldErrorState(state: Bool, message: String?, textfield: ReceiverFormViewModel.ReceiverFormInputFieldType) {
        switch textfield {
        case .fullName:
            self.fullNameTextView.updateStateTo(isError: state, error: message)
        case .motherName:
            self.motherNameTextView.updateStateTo(isError: state, error: message)
        case .birthPlace:
            self.birthPlaceTextView.updateStateTo(isError: state, error: message)
        case .cnic:
            self.cnicTextView.updateStateTo(isError: state, error: message)
        case .cnicIssueDate:
            self.cnicIssueDateTextView.updateStateTo(isError: state, error: message)
        case .countryOfResidence:
            self.countryTextView.updateStateTo(isError: state, error: message)
        case .mobileNumber:
            self.mobileNumberTextView.updateStateTo(isError: state, error: message)
        case .bankName:
            self.bankNameTextView.updateStateTo(isError: state, error: message)
        case .bankNumber:
            self.bankNumberTextView.updateStateTo(isError: state, error: message)
        }
    }
    
    private func focusTextfield(textFieldType: ReceiverFormViewModel.ReceiverFormInputFieldType) {
        switch textFieldType {
        case .fullName:
            self.fullNameTextView.becomeFirstResponder()
        case .motherName:
            self.motherNameTextView.becomeFirstResponder()
        case .birthPlace:
            self.birthPlaceTextView.becomeFirstResponder()
        case .cnic:
            self.cnicTextView.becomeFirstResponder()
        case .cnicIssueDate:
            self.cnicIssueDateTextView.becomeFirstResponder()
        case .countryOfResidence:
            self.countryTextView.becomeFirstResponder()
        case .mobileNumber:
            self.mobileNumberTextView.becomeFirstResponder()
        case .bankName:
            self.bankNameTextView.becomeFirstResponder()
        case .bankNumber:
            self.bankNumberTextView.becomeFirstResponder()
        }
    }
    
    // MARK: - IBActions

    @IBAction func nextBtnAction(_ sender: Any) {
        viewModel.nextButtonPressed()
    }
}

// MARK: Extension - CustomDatePickerViewDelegate

extension ReceiverFormViewController: CustomDatePickerViewDelegate {

    func didTapDoneButton(picker: CustomDatePickerView, date: Date) {
        self.view.endEditing(true)
        switch picker {
        case self.cnicIssueDatePicker:
            self.viewModel.cnicIssueDate = date
        default:
            break
        }
    }
    
    func didTapCancelButton() {
        self.view.endEditing(true)
    }
}

// MARK: Extension - Initializable

extension ReceiverFormViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.receiverForm
    }
}

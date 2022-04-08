//
//  NadraVerificationFormViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 03/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class NadraVerificationFormViewController: BaseViewController {
    
    var viewModel: NadraVerificationFormViewModelProtocol!
    
    private lazy var cnicIssueDatePicker: CustomDatePickerView = {
        var pickerView = CustomDatePickerView()
        pickerView.toolbarDelegate = self
        pickerView.viewModel = viewModel.datePickerViewModel
        return pickerView
    }()
    
    @IBOutlet private weak var verifyCTAButton: PrimaryCTAButton! {
        didSet {
            verifyCTAButton.setTitle("Verify".localized, for: .normal)
        }
    }
    
    @IBOutlet private weak var fullNameTextView: LabelledTextview! {
        didSet {
            fullNameTextView.titleLabelText = "Full Name *".localized
            fullNameTextView.placeholderText = "Muhammad Ali".localized
            fullNameTextView.autoCapitalizationType = .words
            fullNameTextView.inputFieldMaxLength = 50
            fullNameTextView.showHelpBtn = false
            fullNameTextView.editTextKeyboardType = .asciiCapable
            fullNameTextView.formatValidator = FormatValidator(regex: RegexConstants.nameRegex, invalidFormatError: StringConstants.ErrorString.nameError.localized)
            fullNameTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.fullName = updatedText
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
    @IBOutlet private weak var cnicIssueDateTextView: LabelledTextview! {
        didSet {
            cnicIssueDateTextView.titleLabelText = "CNIC/NICOP Issuance Date *".localized
            cnicIssueDateTextView.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            cnicIssueDateTextView.showHelpBtn = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModelOutput()
        self.setupView()
    }
    
    @IBAction private func didTapNextButton(_ sender: Any) {
        viewModel.verifyButtonPressed()
    }
    
    private func setupView() {
        self.title = "NADRA Verification".localized
    }
    
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .updateCnicIssueDate(dateStr: let dateStr):
                self.cnicIssueDateTextView.inputText = dateStr
            case .updateBirthPlace(name: let name):
                self.birthPlaceTextView.inputText = name
            case .nextButtonState(enableState: let enableState):
                self.verifyCTAButton.isEnabled = enableState
            case .textField(errorState: let errorState, error: let error, textfieldType: let textfieldType):
                self.setTextFieldErrorState(error: errorState, message: error, field: textfieldType)
            case .focusField(type: let type):
                self.focus(field: type)
            case .showActivityIndicator(show: let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(error: let error):
                self.showAlert(with: error)
            }
        }
    }
    
    private func focus(field: NadraVerificationFormViewModel.NadraVerificationTextfieldTypes) {
        switch field {
        case .fullName:
            fullNameTextView.becomeFirstResponder()
        case .motherMaidenName:
            motherNameTextView.becomeFirstResponder()
        case .birthPlace:
            birthPlaceTextView.becomeFirstResponder()
        case .cnicIssueDate:
            cnicIssueDateTextView.becomeFirstResponder()
        }
    }
    
    private func setTextFieldErrorState(error: Bool, message: String?, field: NadraVerificationFormViewModel.NadraVerificationTextfieldTypes) {
        switch field {
        case .fullName:
            fullNameTextView.updateStateTo(isError: error, error: message)
        case .motherMaidenName:
            motherNameTextView.updateStateTo(isError: error, error: message)
        case .birthPlace:
            birthPlaceTextView.updateStateTo(isError: error, error: message)
        case .cnicIssueDate:
            cnicIssueDateTextView.updateStateTo(isError: error, error: message)
        }
        
    }
}

extension NadraVerificationFormViewController: CustomDatePickerViewDelegate {
    
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

extension NadraVerificationFormViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.nadraVerificationForm
    }
}

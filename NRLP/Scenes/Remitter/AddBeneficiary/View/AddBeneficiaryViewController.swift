//
//  AddBeneficiaryViewController.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class AddBeneficiaryViewController: BaseViewController {

    var viewModel: AddBeneficiaryViewModelProtocol!
    private lazy var itemPickerView: ItemPickerView! = {
        var pickerView = ItemPickerView()
        pickerView.toolbarDelegate = self
        pickerView.viewModel = viewModel.relationshipPickerViewModel
        return pickerView
    }()
    @IBOutlet private weak var scrollViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet private weak var cnicTextField: LabelledTextview! {
        didSet {
            cnicTextField.titleLabelText = "CNIC/ NICOP *".localized
            cnicTextField.placeholderText = "xxxxx-xxxxxxx-x".localized
            cnicTextField.editTextKeyboardType = .asciiCapableNumberPad
            cnicTextField.formatter = CNICFormatter()
            cnicTextField.inputFieldMinLength = 13
            cnicTextField.inputFieldMaxLength = 13
            cnicTextField.formatValidator = CNICFormatValidator(regex: RegexConstants.cnicRegex, invalidFormatError: StringConstants.ErrorString.cnicError.localized)
            cnicTextField.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.cnic = updatedText
            }
        }
    }

    @IBOutlet private weak var aliasTextField: LabelledTextview! {
        didSet {
            aliasTextField.titleLabelText = "Full Name *".localized
            aliasTextField.placeholderText = "Muhammad Ali".localized
            aliasTextField.inputFieldMaxLength = 50
            aliasTextField.editTextKeyboardType = .asciiCapable
            aliasTextField.autoCapitalizationType = .words
            aliasTextField.formatValidator = FormatValidator(regex: RegexConstants.nameRegex, invalidFormatError: StringConstants.ErrorString.fullNameError.localized)
            aliasTextField.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.name = updatedText
            }
        }
    }

    @IBOutlet private weak var countryTextField: LabelledTextview! {
        didSet {
            countryTextField.titleLabelText = "Country of Residence *".localized
            countryTextField.placeholderText = "Select Country".localized
            countryTextField.isEditable = false
            countryTextField.isTappable = true
            countryTextField.editTextKeyboardType = .asciiCapable
            countryTextField.editTextCursorColor = .init(white: 1, alpha: 0)
            countryTextField.onTextFieldTapped = { [weak self] in
                guard let self = self else { return }
                self.viewModel.openCountryPicker()
            }
        }
    }
    @IBOutlet private weak var mobileTextField: LabelledTextview! {
        didSet {
            mobileTextField.titleLabelText = "Beneficiary Mobile Number *".localized
            mobileTextField.placeholderText = "+xx xxx xxx xxxx".localized
            mobileTextField.editTextKeyboardType = .asciiCapableNumberPad
            mobileTextField.isEditable = false
            mobileTextField.formatValidator = FormatValidator(regex: RegexConstants.mobileNumberRegex, invalidFormatError: StringConstants.ErrorString.mobileNumberError.localized)
            mobileTextField.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.mobileNumber = updatedText
            }
        }
    }
    @IBOutlet private weak var chooseBeneficiaryRelationshipTextField: LabelledTextview! {
        didSet {
            chooseBeneficiaryRelationshipTextField.titleLabelText = "Beneficiary Relation Type *".localized
            chooseBeneficiaryRelationshipTextField.trailingIcon = #imageLiteral(resourceName: "dropdownArrow")
            chooseBeneficiaryRelationshipTextField.placeholderText = "Select Beneficiary Relation Type".localized
            chooseBeneficiaryRelationshipTextField.editTextCursorColor = .init(white: 1, alpha: 0)
            chooseBeneficiaryRelationshipTextField.inputTextFieldInputPickerView = itemPickerView
            
        }
    }
    
    @IBOutlet private weak var beneficiaryRelationshipTextField: LabelledTextview! {
        didSet {
            beneficiaryRelationshipTextField.titleLabelText = "Beneficiary Relation *".localized
            beneficiaryRelationshipTextField.placeholderText = "Enter Beneficiary Relation ".localized
            beneficiaryRelationshipTextField.editTextKeyboardType = .alphabet
            beneficiaryRelationshipTextField.isEditable = true
            beneficiaryRelationshipTextField.formatValidator = FormatValidator(regex: RegexConstants.beneficiaryRelation, invalidFormatError: "Please provide valid relationship")
            beneficiaryRelationshipTextField.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.beneficiaryRelation = updatedText
            }
        }
    }
    @IBOutlet private weak var addBeneficiaryButton: PrimaryCTAButton! {
        didSet {
            addBeneficiaryButton.setTitle("Add Beneficiary".localized, for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModelOutput()
        setupKeyboardNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
    }

    private func setupUI() {

        self.title = "Manage Beneficiaries".localized

        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.checkCountrySelection(sender:)))
        self.mobileTextField.addGestureRecognizer(gesture)
    }

    @objc func checkCountrySelection(sender: UITapGestureRecognizer) {
        //
    }
}

// MARK: Setup View and Bindings
extension AddBeneficiaryViewController {
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .showError(let error):
                self.showAlert(with: error)
            case .addButtonState(let enabled):
                self.addBeneficiaryButton.isEnabled = enabled
            case .nameTextField(let errorState, let error):
                self.aliasTextField.updateStateTo(isError: errorState, error: error)
            case .cnicTextField(let errorState, let error):
                self.cnicTextField.updateStateTo(isError: errorState, error: error)
            case .mobileNumberTextField(let errorState, let error):
                self.mobileTextField.updateStateTo(isError: errorState, error: error)
            case .updateMobileCode(let code):
                self.mobileTextField.leadingText = code
                self.mobileTextField.inputText = ""
            case .showAlert(let alert):
                self.showAlert(with: alert)
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .updateMobilePlaceholder(let placeholder, let length):
                self.mobileTextField.placeholderText = placeholder
                self.mobileTextField.isEditable = true
                self.mobileTextField.inputFieldMinLength = 1
//                self.mobileTextField.inputFieldMaxLength = length
                self.mobileTextField.becomeFirstResponder()
            case .updateCountry(let countryName):
                self.countryTextField.inputText = countryName
            case .updateRelationshipType(inputText: let inputText):
                self.chooseBeneficiaryRelationshipTextField.inputText = inputText
            case .showBeneficiaryTextField(isVisible: let isVisible):
                self.chooseBeneficiaryRelationshipTextField.inputText = RelationshipType.other.getTitle()
                self.beneficiaryRelationshipTextField.isHidden = !isVisible
                self.beneficiaryRelationshipTextField.inputText = ""
            }
        }
    }
}

extension AddBeneficiaryViewController {
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollViewBottomConstraint.constant = keyboardSize.height - 66
        }
    }

    @objc
    private func keyboardWillHide(sender: NSNotification) {
        scrollViewBottomConstraint.constant = 16
    }
}

extension AddBeneficiaryViewController {
    @IBAction
    private func addBeneficiaryClicked(_ sender: PrimaryCTAButton) {
        viewModel.addButtonPressed()
    }
}

extension AddBeneficiaryViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.addBeneficiary
    }
}

extension AddBeneficiaryViewController: ItemPickerViewDelegate {
    func didTapCancelButton() {
        self.view.endEditing(true)
    }

    func didTapDoneButton(with selectedItem: PickerItemModel?) {
        viewModel.didSelect(relationshipTypeItem: selectedItem as? RelationshipTypePickerItemModel)
        self.view.endEditing(true)
    }
}

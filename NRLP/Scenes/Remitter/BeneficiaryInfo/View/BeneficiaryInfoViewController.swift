//
//  BeneficiaryInfoViewController.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class BeneficiaryInfoViewController: BaseViewController {

    var viewModel: BeneficiaryInfoViewModelProtocol!
    
    private lazy var itemPickerView: ItemPickerView! = {
        var pickerView = ItemPickerView()
        pickerView.toolbarDelegate = self
        pickerView.viewModel = viewModel.relationshipPickerViewModel
        return pickerView
    }()

    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerLbl: UILabel! {
        didSet {
            timerLbl.textColor = .white
            timerLbl.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
        }
    }
    
    @IBOutlet weak var editStackView: UIStackView!
    @IBOutlet weak var updateStackView: UIStackView!
    
    @IBOutlet private weak var cnicTextField: LabelledTextview! {
        didSet {
            cnicTextField.titleLabelText = "CNIC/NICOP".localized
            cnicTextField.placeholderText = "4250180532901".localized
            cnicTextField.editTextKeyboardType = .asciiCapableNumberPad
            cnicTextField.formatter = CNICFormatter()
            cnicTextField.isEditable = false
            cnicTextField.inputText = viewModel.cnic
            cnicTextField.onTextFieldChanged = { [unowned self] updatedText in
                self.viewModel.cnic = updatedText
            }
        }
    }

    @IBOutlet private weak var aliasTextField: LabelledTextview! {
        didSet {
            aliasTextField.titleLabelText = "Full Name".localized
            aliasTextField.placeholderText = "Muhammad Ali".localized
            aliasTextField.isEditable = false
            aliasTextField.editTextKeyboardType = .asciiCapable
            aliasTextField.inputText = viewModel.name
            aliasTextField.onTextFieldChanged = { [unowned self] updatedText in
                self.viewModel.name = updatedText
            }
        }
    }
    
    @IBOutlet private weak var countryTextField: LabelledTextview! {
        didSet {
            countryTextField.titleLabelText = "Country of Residence".localized
            countryTextField.placeholderText = "".localized
            countryTextField.editTextKeyboardType = .asciiCapableNumberPad
            countryTextField.isEditable = false
            countryTextField.inputText = viewModel.countryName
            countryTextField.isTappable = false
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
            mobileTextField.titleLabelText = "Beneficiary Mobile Number".localized
            mobileTextField.placeholderText = "+xx xxx xxx xxxx".localized
            mobileTextField.editTextKeyboardType = .asciiCapableNumberPad
            mobileTextField.isEditable = false
            mobileTextField.inputText = viewModel.mobileNumber
            mobileTextField.onTextFieldChanged = { [unowned self] updatedText in
                self.viewModel.mobileNumber = updatedText
            }
        }
    }
    
    @IBOutlet private weak var relationTextField: LabelledTextview! {
        didSet {
            relationTextField.titleLabelText = "Beneficiary Relation Type".localized
            relationTextField.placeholderText = "Select Beneficiary Relation Type".localized
            relationTextField.editTextKeyboardType = .asciiCapableNumberPad
            relationTextField.isEditable = false
            relationTextField.inputTextFieldInputPickerView = itemPickerView
            relationTextField.inputText = viewModel.relation
        }
    }
    
    @IBOutlet private weak var customRelationTextField: LabelledTextview! {
        didSet {
            customRelationTextField.titleLabelText = "Beneficiary Relation".localized
            customRelationTextField.placeholderText = "Enter Beneficiary Relation".localized
            customRelationTextField.editTextKeyboardType = .asciiCapableNumberPad
            customRelationTextField.inputText = viewModel.customRelation
            customRelationTextField.onTextFieldChanged = { [weak self] updatedText in
                    guard let self = self else { return }
                    self.viewModel.relation = updatedText
                }
        }
    }

    @IBOutlet private weak var deleteBeneficiaryButton: PrimaryCTAButton! {
        didSet {
            deleteBeneficiaryButton.setTitle("Delete Beneficiary".localized, for: .normal)
        }
    }
    
    @IBOutlet private weak var editBeneficiaryButton: PrimaryCTAButton! {
        didSet {
//            editBeneficiaryButton.isHidden = true
            editBeneficiaryButton.setTitle("Edit".localized, for: .normal)
        }
    }
    @IBOutlet private weak var resendOTPBeneficiaryButton: PrimaryCTAButton! {
        didSet {
            resendOTPBeneficiaryButton.setTitle("Resend Registration Code".localized, for: .normal)
        }
    }
    @IBOutlet private weak var updateBeneficiaryButton: PrimaryCTAButton! {
        didSet {
            updateBeneficiaryButton.setTitle("Update".localized, for: .normal)
        }
    }
    @IBOutlet private weak var cancelBeneficiaryButton: SecondaryCTAButton! {
        didSet {
            cancelBeneficiaryButton.setTitle("Cancel".localized, for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModelOutput()
        viewModel.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopTimer()
    }

    private func setupUI() {
        self.title = "Beneficiary Details".localized
        self.timerView.backgroundColor = UIColor.init(commonColor: .appLightGray)
        timerLbl.text = ""
    }

}

// MARK: Setup View and Bindings
extension BeneficiaryInfoViewController {
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .showError(let error):
                self.showAlert(with: error)
            case .deleteButtonState:
                self.deleteBeneficiaryButton.isEnabled = true
            case .showAlert(let alert):
                self.showAlert(with: alert)
            case .dismissAlert:
                print("Dismiss")
            case .showActivityIndicator(let show):
                DispatchQueue.main.async {
                    show ? ProgressHUD.show() : ProgressHUD.dismiss()
                }
            case .shouldShowEditStackView(show: let show):
                editStackView.isHidden = !show
            case .shouldShowUpdateStackView(show: let show):
                updateStackView.isHidden = !show
            case .editTextFields(isEditable: let isEditable):
                cnicTextField.isEditable = isEditable
                countryTextField.isTappable = isEditable
//                aliasTextField.isEditable = isEditable
                mobileTextField.isEditable = isEditable
//                relationTextField.isEditable = isEditable
            case .resetBeneficiary(beneficiary: let beneficiary):
                cnicTextField.inputText = "\(beneficiary.nicNicop)"
                aliasTextField.inputText = beneficiary.alias
                mobileTextField.inputText = beneficiary.mobileNo
                relationTextField.inputText = beneficiary.beneficiaryRelation
                countryTextField.inputText = beneficiary.country
            case .nameTextField(errorState: let errorState, errorMessage: let errorMessage):
                aliasTextField.updateStateTo(isError: errorState, error: errorMessage)
            case .cnicTextField(errorState: let errorState, errorMessage: let errorMessage):
                cnicTextField.updateStateTo(isError: errorState, error: errorMessage)
            case .mobileNumberTextField(errorState: let errorState, errorMessage: let errorMessage):
                mobileTextField.updateStateTo(isError: errorState, error: errorMessage)
            case .customRelationTextField(errorState: let errorState, errorMessage: let errorMessage):
                customRelationTextField.updateStateTo(isError: errorState, error: errorMessage)
            case .countryTextField(errorState: let errorState, errorMessage: let errorMessage):
                countryTextField.updateStateTo(isError: errorState, error: errorMessage)
            case .updateRelationshipType(inputText: let inputText):
                self.relationTextField.inputText = inputText
            case .showBeneficiaryTextField(isVisible: let isVisible):
                self.relationTextField.inputText = RelationshipType.other.getTitle()
                self.customRelationTextField.isHidden = !isVisible
            case .clearCustomRelationTextField:
                self.customRelationTextField.inputText = ""
            case .updateMobilePlaceholder(let placeholder):
                self.mobileTextField.placeholderText = placeholder
                self.mobileTextField.isEditable = true
                self.mobileTextField.inputFieldMinLength = 1
                self.mobileTextField.becomeFirstResponder()
            case .updateCountry(let countryName):
                self.countryTextField.inputText = countryName
            case .updateMobileCode(let code):
                self.mobileTextField.leadingText = code
                self.mobileTextField.inputText = ""
            case .showResendTimer(show: let show):
                // This feature was used to display a countdown timer in place of Resend Registration Code
                // Now Removed
                
                timerView.isHidden = true // !show
                resendOTPBeneficiaryButton.isHidden = false // show
                
                if show {
                    viewModel.startTimer()
                }
            }
        }
    }
}

// MARK: IBActions
extension BeneficiaryInfoViewController {
    @IBAction
    private func deleteBeneficiaryPressed(_ sender: PrimaryCTAButton) {
        viewModel.deleteButtonPressed()
    }
    
    @IBAction
    private func editBeneficiaryPressed(_ sender: PrimaryCTAButton) {
        viewModel.editButtonPressed()
    }
    
    @IBAction
    private func resendOTPPressed(_ sender: PrimaryCTAButton) {
        viewModel.resendOTPButtonPressed()
    }
    
    @IBAction
    private func updateBeneficiaryPressed(_ sender: PrimaryCTAButton) {
        viewModel.updateButtonPressed()
    }
    
    @IBAction
    private func cancelBeneficiaryPressed(_ sender: SecondaryCTAButton) {
        viewModel.cancelButtonPressed()
    }
}

extension BeneficiaryInfoViewController: ItemPickerViewDelegate {
    func didTapCancelButton() {
        self.view.endEditing(true)
    }

    func didTapDoneButton(with selectedItem: PickerItemModel?) {
        viewModel.didSelect(relationshipTypeItem: selectedItem as? RelationshipTypePickerItemModel)
        self.view.endEditing(true)
    }
}

extension BeneficiaryInfoViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.beneficiaryInfo
    }
}

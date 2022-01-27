//
//  ComplaintFormViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 26/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class ComplaintFormViewController: BaseViewController {
    
    var viewModel: ComplaintFormViewModel!

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
            complaintLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .largeFontSize)
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
            cnicTextView.titleLabelText = "CNIC/NICOP".localized
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
                self.viewModel.countryTextFieldTapped()
            }
        }
    }
    @IBOutlet private weak var mobileNumberTextView: LabelledTextview! {
        didSet {
            mobileNumberTextView.titleLabelText = "Mobile Number *".localized
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
            fullNameTextView.editTextKeyboardType = .asciiCapable
            fullNameTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.name = updatedText
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
    
    override func viewDidLoad() {
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
            }
        }
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        viewModel.nextButtonPressed()
    }
    
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
    
    private func showUnregisteredRemitterFields(complaint: ComplaintTypes) {
        switch complaint {
        case .unableToRegister:
            fullNameTextView.isHidden = false
            cnicTextView.isHidden = false
            countryTextView.isHidden = false
            mobileNumberTextView.isHidden = false
            emailAddressTextView.isHidden = false
//            specifyDetailsTextArea.isHidden = false
        case .unableToReceiveOTP:
            fullNameTextView.isHidden = false
            cnicTextView.isHidden = false
            countryTextView.isHidden = false
            mobileNumberTextView.isHidden = false
            mobileOperatorTextView.isHidden = true
            emailAddressTextView.isHidden = false
        case .others:
            ()
        default:
            hideAllTextFields()
        }
    }
    
    private func showRegisteredRemitterFields(complaint: ComplaintTypes) {
        switch complaint {
        case .unableToReceiveOTP:
            ()
        case .unableToAddBeneficiary:
            ()
        case .unableToTransferPointsToBeneficiary:
            ()
        case .unableToSelfAwardPoints:
            ()
        case .redemptionIssues:
            ()
        case .others:
            ()
        default:
            hideAllTextFields()
        }
    }
    
    private func showUnregisteredBeneficiaryFields(complaint: ComplaintTypes) {
        switch complaint {
        
        case .unableToRegister:
            ()
        case .unableToReceiveOTP:
            ()
        case .others:
            ()
        default:
            hideAllTextFields()
        }
    }
    
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
    
    private func hideAllTextFields() {
        fullNameTextView.isHidden = true
        cnicTextView.isHidden = true
        countryTextView.isHidden = true
        mobileNumberTextView.isHidden = true
        mobileOperatorTextView.isHidden = true
        emailAddressTextView.isHidden = true
//        specifyDetailsTextArea.isHidden = true
        
    }

}

extension ComplaintFormViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.complaintForm
    }
}

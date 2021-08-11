//
//  ChangePasswordViewController.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController {

    var viewModel: ChangePasswordViewModelProtocol!

    @IBOutlet private weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = "Your password must contain at least 8 characters, including 1 small letter, 1 capital letter, 1 number and 1 special character.".localized
            descriptionLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
        }
    }

    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var oldPasswordTextView: LabelledTextview! {
        didSet {
            oldPasswordTextView.titleLabelText = "Enter Old Password".localized
            oldPasswordTextView.placeholderText = "Password@123".localized
            oldPasswordTextView.inputFieldMaxLength = 50
            oldPasswordTextView.editTextKeyboardType = .asciiCapable
            oldPasswordTextView.secureEntry = true
            oldPasswordTextView.formatValidator = FormatValidator(regex: RegexConstants.loginPaasswordRegex, invalidFormatError: StringConstants.ErrorString.incorrectOldPaassword.localized)
            oldPasswordTextView.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.oldPaassword = updatedText
            }
        }
    }

    @IBOutlet private weak var newPasswordTextLabel: LabelledTextview! {
        didSet {
            newPasswordTextLabel.titleLabelText = "Enter New Password".localized
            newPasswordTextLabel.placeholderText = "Password@123".localized
            newPasswordTextLabel.inputFieldMaxLength = 50
            newPasswordTextLabel.editTextKeyboardType = .asciiCapable
            newPasswordTextLabel.secureEntry = true
            newPasswordTextLabel.formatValidator = FormatValidator(regex: RegexConstants.paasswordRegex, invalidFormatError: StringConstants.ErrorString.paasswordCritriaError.localized)
            newPasswordTextLabel.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.paassword = updatedText
            }
        }
    }

    @IBOutlet private weak var retypeNewPasswordTextLabel: LabelledTextview! {
        didSet {
            retypeNewPasswordTextLabel.titleLabelText = "Re-enter New Password".localized
            retypeNewPasswordTextLabel.placeholderText = "Password@123".localized
            retypeNewPasswordTextLabel.inputFieldMaxLength = 50
            retypeNewPasswordTextLabel.secureEntry = true
            retypeNewPasswordTextLabel.editTextKeyboardType = .asciiCapable
            retypeNewPasswordTextLabel.formatValidator = FormatValidator(regex: RegexConstants.paasswordRegex, invalidFormatError: StringConstants.ErrorString.paasswordError.localized)
            retypeNewPasswordTextLabel.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.rePaassword = updatedText
            }
            retypeNewPasswordTextLabel.onTextFieldFocusChange = { [weak self] password in
                guard let self = self else { return }
                self.viewModel.validateConfirmPassword()
            }
        }
    }

    @IBOutlet private weak var doneButton: PrimaryCTAButton! {
        didSet {
            doneButton.setTitle("Save".localized, for: .normal)
        }
    }

    @IBAction
    private func saveButtonPressed(_ sender: PrimaryCTAButton) {
        viewModel.doneButtonPressed()
        self.view.endEditing(true)
    }

    override
    func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.bindViewModelOutput()
        setupKeyboardNotification()

    }
}

// MARK: Setup View and Bindings
extension ChangePasswordViewController {
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                self.showAlert(with: error)
            case .doneButtonState(let enableState):
                self.doneButton.isEnabled = enableState
            case .oldPasswordTextField(let errorState, let errorMsg):
                self.oldPasswordTextView.updateStateTo(isError: errorState, error: errorMsg)
            case .passwordTextField(let errorState, let errorMsg):
                self.newPasswordTextLabel.updateStateTo(isError: errorState, error: errorMsg)
            case .rePasswordTextField(let errorState, let errorMsg):
                self.retypeNewPasswordTextLabel.updateStateTo(isError: errorState, error: errorMsg)
            }
        }
    }

    private func setupView() {
        self.title = "Change Password".localized
    }
    
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollViewBottomConstraint.constant = keyboardSize.height - 50
        }
    }

    @objc
    private func keyboardWillHide(sender: NSNotification) {
        scrollViewBottomConstraint.constant = 16
    }
}

extension ChangePasswordViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.changePassword
    }
}

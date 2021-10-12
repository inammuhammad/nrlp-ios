//
//  ForgotPasswordNewPassViewController.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 15/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class ForgotPasswordNewPassViewController: BaseViewController {

    var viewModel: ForgotPasswordNewPassViewModelProtocol!

    @IBOutlet private weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = "Your password must contain at least 8 characters, including 1 small letter, 1 capital letter, 1 number and 1 special character.".localized
            descriptionLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
        }
    }
    @IBOutlet private weak var newPasswordTextField: LabelledTextview! {
        didSet {
            newPasswordTextField.titleLabelText = "New Password".localized
            newPasswordTextField.placeholderText = "Password@123".localized
            newPasswordTextField.secureEntry = true
            newPasswordTextField.isPasswordField = true
            newPasswordTextField.editTextKeyboardType = .asciiCapable
            newPasswordTextField.formatValidator = FormatValidator(regex: RegexConstants.paasswordRegex, invalidFormatError: StringConstants.ErrorString.paasswordCritriaError.localized)
            newPasswordTextField.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.newPassword = updatedText
            }
        }
    }
    @IBOutlet private weak var redoNewPasswordTextField: LabelledTextview! {
        didSet {
            redoNewPasswordTextField.titleLabelText = "Re - Enter New Password".localized
            redoNewPasswordTextField.placeholderText = "Password@123".localized
            redoNewPasswordTextField.secureEntry = true
            redoNewPasswordTextField.isPasswordField = true
            newPasswordTextField.editTextKeyboardType = .asciiCapable
            redoNewPasswordTextField.formatValidator = FormatValidator(regex: RegexConstants.paasswordRegex, invalidFormatError: StringConstants.ErrorString.paasswordCritriaError.localized)
            redoNewPasswordTextField.onTextFieldChanged = { [weak self] updatedText in
                guard let self = self else { return }
                self.viewModel.redoNewPassword = updatedText
            }
            redoNewPasswordTextField.onTextFieldFocusChange = { [weak self] password in
                guard let self = self else { return }
                self.viewModel.validateConfirmPassword()
            }
        }
    }

    @IBOutlet private weak var confirmButton: PrimaryCTAButton! {
        didSet {
            confirmButton.setTitle("Confirm".localized, for: .normal)
        }
    }

    override
    func back(sender: UIBarButtonItem) {
        viewModel.didTapBackButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModelOutput()
    }

    private func setupUI() {
        self.title = "Forgot Password".localized
    }

}

extension ForgotPasswordNewPassViewController {
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .showError(let error):
                self.showAlert(with: error)
            case .nextButtonState(let enableState):
                self.confirmButton.isEnabled = enableState
            case .newPasswordTextField(let errorState, let errorMsg):
                self.newPasswordTextField.updateStateTo(isError: errorState, error: errorMsg)
            case .retypeNewPasswordTypeTextField(let errorState, let errorMsg):
                self.redoNewPasswordTextField.updateStateTo(isError: errorState, error: errorMsg)
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            }
        }
    }

    @IBAction
    private func confirmButtonPressed(_ sender: PrimaryCTAButton) {
        self.viewModel.navigateToFinishScreen()
    }
}

extension ForgotPasswordNewPassViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.forgotPasswordNewPass
    }
}

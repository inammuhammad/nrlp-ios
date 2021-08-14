//
//  LoginViewController.swift
//  1Link-NRLP
//
//  Created by ajmal on 06/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {

    // MARK: Outlets
    @IBOutlet weak var headerLabel: PrimaryHeaderTitle! {
        didSet {
            headerLabel.text = "National Remittance \nLoyalty Program".localized
        }
    }
    @IBOutlet weak var aboutNRLPButton: UIButton! {
        didSet {
            
            aboutNRLPButton.setTitle("About NRLP".localized, for: .normal)
            aboutNRLPButton.setTitleColor(.init(commonColor: .appGreen), for: .normal)
            aboutNRLPButton.titleLabel?.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
        }
    }
    @IBOutlet weak var cnicLabelTextView: LabelledTextview! {
        didSet {
            cnicLabelTextView.titleLabelText = "CNIC/NICOP".localized
            cnicLabelTextView.editTextKeyboardType = .asciiCapableNumberPad
            cnicLabelTextView.formatter = CNICFormatter()
            cnicLabelTextView.formatValidator = CNICFormatValidator(regex: RegexConstants.cnicRegex, invalidFormatError: StringConstants.ErrorString.cnicError.localized)
            cnicLabelTextView.placeholderText = "42501 - 8053290 - 1".localized
        }
    }
    @IBOutlet weak var forgotPasswordButton: UIButton! {
        didSet {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .smallFontSize),
                .foregroundColor: UIColor.init(commonColor: .appGreen)]
            let attributeString = NSMutableAttributedString(string: "Forgot Password".localized,
                                                            attributes: attributes)
            forgotPasswordButton.setAttributedTitle(attributeString, for: .normal)

        }
    }
    @IBOutlet weak var passwordLabelTextView: LabelledTextview! {
        didSet {
            passwordLabelTextView.editTextKeyboardType = .asciiCapable
            passwordLabelTextView.titleLabelText = "Password".localized
            passwordLabelTextView.placeholderText = "Password@123".localized
            passwordLabelTextView.formatValidator = FormatValidator(regex: RegexConstants.loginPaasswordRegex, invalidFormatError: StringConstants.ErrorString.paasswordError.localized)
        }
    }
    @IBOutlet weak var loginButton: PrimaryCTAButton! {
        didSet {
            loginButton.setTitle("Login".localized, for: .normal)
        }
    }
    @IBOutlet weak var accountLabel: UILabel! {
        didSet {
            accountLabel.text = "Don't have an account?".localized
            accountLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
        }
    }
    @IBOutlet weak var registerButton: UIButton! {
        didSet {
            let attributedTitle = NSAttributedString(string: "Register".localized,
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(commonColor: .appGreen),
                                                                  NSAttributedString.Key.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)])
            registerButton.setAttributedTitle(attributedTitle, for: .normal)
        }
    }
    @IBOutlet weak var accountTypeRadioButton: RadioButtonView! {
        didSet {
            accountTypeRadioButton.titleViewText = "Select User Type".localized
            accountTypeRadioButton.setRadioButtonItems(items: viewModel.accountTypeItemModel)
            accountTypeRadioButton.setRadioItemSelected(at: 0, isSelected: true)
            accountTypeRadioButton.didUpdatedSelectedItem = { [weak self] item in
                guard let self = self else { return }
                self.view.endEditing(true)
                self.viewModel.accountType = item.key
            }
        }
    }

    // MARK: Variables
    var viewModel: LoginViewModelProtocol!

    // MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModelOutput()
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        resetData()
        viewModel.viewWillAppear()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: Private Methods
    private func setupUI() {

        cnicLabelTextView.onTextFieldChanged = { [weak self] updatedText in
            guard let self = self else { return }
            self.viewModel.cnic = updatedText
        }
        passwordLabelTextView.onTextFieldChanged = { [weak self] updatedText in
            guard let self = self else { return }
            self.viewModel.paassword = updatedText
        }
    }

    func resetData() {

        cnicLabelTextView.inputText = ""
        passwordLabelTextView.inputText = ""
        accountTypeRadioButton.setRadioItemSelected(at: 0, isSelected: true)
        cnicLabelTextView.updateStateTo(isError: false)
        passwordLabelTextView.updateStateTo(isError: false)
        loginButton.isEnabled = false
        viewModel.resetData()
    }

    /// Bind the view controller with view model.
    private func bindViewModelOutput() {
        viewModel.output = { [unowned self] output in
            switch output {
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                self.showAlert(with: error)
            case .loginButtonState(let state):
                self.loginButton.isEnabled = state
            case .cnicLabelState(let error, let errorMsg):
                self.cnicLabelTextView.updateStateTo(isError: error, error: errorMsg)
            case .passwordLabelState(let error, let errorMsg):
                self.passwordLabelTextView.updateStateTo(isError: error, error: errorMsg)
            case .jailBroken:
                self.showAlert(with: AlertViewModel(alertHeadingImage: .ohSnap, alertTitle: StringConstants.ErrorString.serverErrorTitle.localized, alertDescription: StringConstants.ErrorString.jailbrokenMsg.localized, primaryButton: AlertActionButtonModel(buttonTitle: "Okay".localized, buttonAction: {
                    exit(0)
                })))
            }
        }
    }
    
    @IBAction func didTapAboutButton(_ sender: Any) {
        AppUtility.goToWebsite(url: AppConstants.aboutNRLPUrl) { (_) in }
    }
}

// MARK: Button Actions
extension LoginViewController {

    @IBAction func registerButtonPressed(_ sender: UIButton) {

        viewModel.registerButtonPreessed()
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {

        viewModel.loginButtonPressed()
    }

    @IBAction func forgotPasswordButtonClicked(_ sender: UIButton) {

        viewModel.forgotPasswordPressed()
    }

}

extension LoginViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.login
    }
}

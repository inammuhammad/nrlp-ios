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
    @IBOutlet weak var bottomStackView: UIStackView!
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
    @IBOutlet weak var viewBenefitsBtn: UIButton! {
        didSet {
            
            viewBenefitsBtn.setTitle("View Sohni Dharti Remittance Program Benefits".localized, for: .normal)
            viewBenefitsBtn.setTitleColor(.init(commonColor: .appGreen), for: .normal)
            viewBenefitsBtn.titleLabel?.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
        }
    }
    @IBOutlet weak var cnicLabelTextView: LabelledTextview! {
        didSet {
            cnicLabelTextView.titleLabelText = "CNIC/NICOP *".localized
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
            passwordLabelTextView.isPasswordField = true
            passwordLabelTextView.titleLabelText = "Password *".localized
            passwordLabelTextView.placeholderText = "Password@123".localized
            passwordLabelTextView.formatValidator = FormatValidator(regex: RegexConstants.paasswordRegex, invalidFormatError: StringConstants.ErrorString.paasswordError.localized)
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
    @IBOutlet weak var aboutBtn: CardImageButton! {
        didSet {
            aboutBtn.imageHeight = 25.0
            aboutBtn.titleLabelText = "About".localized
            aboutBtn.image = UIImage(named: "home-loyalty-statement")
            aboutBtn.onTapped = {
                self.viewModel.aboutButtonPressed()
            }
        }
    }
    @IBOutlet weak var benefitsBtn: CardImageButton! {
        didSet {
            benefitsBtn.imageHeight = 25.0
            benefitsBtn.titleLabelText = "Benefits".localized
            benefitsBtn.image = UIImage(named: "benefits")
            benefitsBtn.onTapped = {
                self.viewModel.benefitsButtonPressed()
            }
        }
    }
    @IBOutlet weak var complaintBtn: CardImageButton! {
        didSet {
            complaintBtn.imageHeight = 25.0
            complaintBtn.titleLabelText = "Complaints".localized
            complaintBtn.image = UIImage(named: "complaints")
            complaintBtn.onTapped = {
//                self.showAlert(with: AlertViewModel(alertHeadingImage: .comingSoon, alertTitle: "Coming Soon".localized, alertDescription: "This feature is coming very soon".localized, alertAttributedDescription: nil, primaryButton: AlertActionButtonModel(buttonTitle: "Okay".localized, buttonAction: nil), secondaryButton: nil))
                self.viewModel.complaintsButtonPressed()
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
        
        // Prefill testing
//        self.viewModel.cnic = "4220157985955"
        // self.viewModel.cnic = "2222200000000"
        self.viewModel.cnic = "2220000000000"
        self.viewModel.paassword = "Abcd@1234"
        self.viewModel.loginButtonPressed()
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
    @IBAction func viewBenefitsBtnAction(_ sender: Any) {
        self.navigationController?.pushViewController(BenefitsBuilder().build(with: navigationController), animated: true)
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

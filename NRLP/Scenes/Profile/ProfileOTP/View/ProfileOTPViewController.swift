//
//  ProfileOTPViewController.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class ProfileOTPViewController: BaseViewController {

    @IBOutlet private weak var verificationCodeErrorLabel: UILabel! {
        didSet {
            verificationCodeErrorLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .extraSmallFontSize)
            verificationCodeErrorLabel.textColor = UIColor(commonColor: .appErrorRed)
        }
    }
    @IBOutlet private weak var resendCodeInfoLabel: UILabel! {
        didSet {
            resendCodeInfoLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
            resendCodeInfoLabel.textColor = .black
            resendCodeInfoLabel.text = "We have sent you a new OTP on your\nregistered mobile no.".localized
        }
    }
    @IBOutlet private weak var resendVerificationCodeInfoView: UIView! {
        didSet {
            resendVerificationCodeInfoView.backgroundColor = UIColor(commonColor: .appTransparentGreen)
            resendVerificationCodeInfoView.cornerRadius = 4
            resendVerificationCodeInfoView.isHidden = true
        }
    }
    @IBOutlet private var codeTextFields: [CodeVerifyTextField]!
    @IBOutlet private weak var headerLabel: UILabel! {
        didSet {
            headerLabel.text = "We have sent you OTP on your registered mobile number, please enter the OTP below".localized
            headerLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
        }
    }
    @IBOutlet private weak var codeExpireTimerLabel: UILabel! {
        didSet {
            codeExpireTimerLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
            codeExpireTimerLabel.textColor = .init(commonColor: .appYellow)
            codeExpireTimerLabel.text = "05:00".localized
        }
    }
    @IBOutlet private weak var codeExpireLabel: UILabel! {
        didSet {
            codeExpireLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
            codeExpireLabel.textColor = .black
            codeExpireLabel.text = "OTP Code will expire in".localized
        }
    }
    @IBOutlet private weak var notReceiveOtpLabel: UILabel! {
        didSet {
            notReceiveOtpLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
            notReceiveOtpLabel.textColor = .black
            notReceiveOtpLabel.text = "Didn't receive the OTP?".localized
        }
    }
    @IBOutlet private weak var resendOtpButton: UIButton! {
        didSet {
            let attributedTitle = NSAttributedString(string: "Resend OTP".localized,
                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(commonColor: .appGreen),
                                                                  NSAttributedString.Key.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)])
            resendOtpButton.setAttributedTitle(attributedTitle, for: .normal)
        }
    }
    @IBOutlet private weak var verifyCTAButton: PrimaryCTAButton! {
        didSet {
            verifyCTAButton.setTitle("Next".localized, for: .normal)
        }
    }
    @IBOutlet weak var otpItemStack: UIStackView!
    
    var viewModel: ProfileOTPViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModelOutput()
        setupView()
    }

    private func setupView() {
        title = "OTP Verification".localized
        viewModel.viewDidLoad()
        setupPinCodeFields()
        enableProfileOTP(state: false)
        
        otpItemStack.semanticContentAttribute = .forceLeftToRight
        codeTextFields.forEach { (textField) in
            textField.semanticContentAttribute = .forceLeftToRight
        }
    }

    private func enableProfileOTP(state: Bool) {

        var attributedTitle = NSAttributedString()

        if state {
            attributedTitle = NSAttributedString(string: "Resend OTP".localized,
                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(commonColor: .appGreen),
                                                              NSAttributedString.Key.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)])
        } else {
            attributedTitle = NSAttributedString(string: "Resend OTP".localized,
                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(commonColor: .appLightGray),
                                                              NSAttributedString.Key.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)])
        }
        resendOtpButton.setAttributedTitle(attributedTitle, for: .normal)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewModelWillDisappear()
    }

    deinit {
        viewModel.viewModelWillDisappear()
    }

    /// Bind the view controller with view model.
    private func bindViewModelOutput() {

        viewModel.output = { [unowned self] output in
            switch output {
            case .showAlert(let alertViewModel):
                self.showAlert(with: alertViewModel)
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                self.showAlert(with: error)
            case .nextButtonState(let state):
                self.verifyCTAButton.isEnabled = state
            case .resendOtpButtonState(let state):
                self.resendOtpButton.isEnabled = state
                self.enableProfileOTP(state: state)
            case .updateCodeExpireTimer(let timerString):
                self.codeExpireTimerLabel.text = timerString
            case .showOTPInvalidFormatError(let show, let error):
                self.verificationCodeErrorLabel.isHidden = !show
                self.verificationCodeErrorLabel.text = error ?? ""
            case .showResendOTPInfoView(let show):
                self.resendVerificationCodeInfoView.isHidden = !show
            }
        }
    }

    private func setupPinCodeFields() {

        codeTextFields.forEach { $0.codeDelegate = self}

        for textfields in codeTextFields {
            textfields.codeDelegate = self
            textfields.placeholder = "x".localized
            textfields.setTextViewBorder(with: UIColor(commonColor: .appBottomBorderViewShadow))
        }
        codeTextFields.first?.becomeFirstResponder()
    }

    private func clearInputFields() {
        codeTextFields.forEach { (textField) in
            textField.clear()
        }
        self.view.endEditing(true)
    }

    @IBAction
    private func didTapResendOtpButton(_ sender: UIButton) {
        clearInputFields()
        viewModel.didTapOnResendOtpButton()
    }
    @IBAction
    private func didTapVerifyButton(_ sender: Any) {
        viewModel.didTapVerifyButton()
    }
}

extension ProfileOTPViewController: KWTextFieldDelegate {

    func moveToNext(_ textFieldView: CodeVerifyTextField) {
        let validIndex = codeTextFields.firstIndex(of: textFieldView) == codeTextFields.count - 1 ? codeTextFields.firstIndex(of: textFieldView)! : codeTextFields.firstIndex(of: textFieldView)! + 1
        textFieldView.setTextViewBorder(with: UIColor(commonColor: .appGreen))
        codeTextFields[validIndex].activate()
    }

    func moveToPrevious(_ textFieldView: CodeVerifyTextField, oldCode: String) {
        if codeTextFields.last == textFieldView && oldCode != " " {
            return
        }
        textFieldView.setTextViewBorder(with: UIColor(commonColor: .appBottomBorderViewShadow))

        if textFieldView.text == " " {
            let validIndex = codeTextFields.firstIndex(of: textFieldView)! == 0 ? 0 : codeTextFields.firstIndex(of: textFieldView)! - 1
            codeTextFields[validIndex].activate()
            codeTextFields[validIndex].reset()
        }
    }

    func didChangeCharacters() {
        var enteredDigits = 0
        let maxDigits = 4

        var verificationCodeString = ""
        var verificationCode =  [Int?]()
        for textFieldView in codeTextFields {

            let value =  Int(textFieldView.text ?? "") ?? nil
            verificationCode.append(value)
            verificationCodeString.append(textFieldView.text ?? "")
            if value != nil {
                enteredDigits += 1
            }
        }
        if enteredDigits == maxDigits {
            view.endEditing(true)
        }
        viewModel.otpCode = verificationCode
    }
}

extension ProfileOTPViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.profileOTP
    }
}

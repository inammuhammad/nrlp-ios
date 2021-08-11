import UIKit

class RedeemOTPViewController: BaseViewController {
    
    var viewModel: RedeemOTPViewModelProtocol!
    
    @IBOutlet private weak var progressBar: ProgressBarView! {
        didSet {
            progressBar.completedPercentage = 0.75
        }
    }
    @IBOutlet private weak var verificationCodeErrorLabel: UILabel! {
        didSet {
            verificationCodeErrorLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .extraSmallFontSize)
            verificationCodeErrorLabel.textColor = UIColor(commonColor: .appErrorRed)
        }
    }
    @IBOutlet private var codeTextFields: [CodeVerifyTextField]!
    @IBOutlet private weak var headerLabel: UILabel! {
        didSet {
            headerLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
        }
    }
    @IBOutlet private weak var resendLabel: UILabel! {
        didSet {
            resendLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
            resendLabel.textColor = .black
            resendLabel.text = "OTP Code will expire in".localized
        }
    }
    @IBOutlet private weak var resendTime: UILabel! {
        didSet {
            resendTime.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
            resendTime.textColor = .init(commonColor: .appYellow)
            resendTime.text = "05:00"
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
            
            let attributedTitle = NSAttributedString(string: "Resend OTP",
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
    @IBOutlet weak var otpItemStack: UIStackView!
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        bindViewModelOutput()
    }
    
    override
    func viewWillDisappear(_ animated: Bool) {
        self.viewModel.viewModelWillDisappear()
    }
    
    private func setupView() {
        self.title = "OTP Verification".localized
        headerLabel.text = String(format: "We have sent you a code on your Mobile number %@. Please enter the code below.".localized, viewModel.formattedNumber)
        
        viewModel.viewDidLoad()
        setupPinCodeFields()
        self.enableOTP(state: false)
        
        otpItemStack.semanticContentAttribute = .forceLeftToRight
        codeTextFields.forEach { (textField) in
            textField.semanticContentAttribute = .forceLeftToRight
        }
    }
    
    private func enableOTP(state: Bool) {
        
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
        self.resendOtpButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    private func clearInputFields() {
        codeTextFields.forEach { (textField) in
            textField.clear()
        }
        self.view.endEditing(true)
    }
    
    /// Bind the view controller with view model.
    private func bindViewModelOutput() {
        
        viewModel.output = { [unowned self] output in
            switch output {
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                self.showAlert(with: error)
            case .nextButtonState(let state):
                self.verifyCTAButton.isEnabled = state
            case .resendOtpButtonState(let state):
                self.resendOtpButton.isEnabled = state
                self.enableOTP(state: state)
            case .showOTPInvalidFormatError(let show, let error):
                self.verificationCodeErrorLabel.isHidden = !show
                self.verificationCodeErrorLabel.text = error ?? ""
            case .updateCodeExpireTimer(let timerString):
                self.resendTime.text = timerString
            case .showResendOTPInfoView(let show):
                self.resendVerificationCodeInfoView.isHidden = !show
            case .showAlert(let alertViewModel):
                self.showAlert(with: alertViewModel)
            }
        }
    }
    
    private func setupPinCodeFields() {
        
        codeTextFields.forEach { $0.codeDelegate = self }
        
        for textfields in codeTextFields {
            textfields.codeDelegate = self
            textfields.placeholder = "x"
            textfields.setTextViewBorder(with: UIColor(commonColor: .appBottomBorderViewShadow))
        }
        codeTextFields.first?.becomeFirstResponder()
    }
    
    @IBAction
    private func didTapResendOtpButton(_ sender: UIButton) {
        clearInputFields()
        self.viewModel.didTapOnResendOtpButton()
    }
    
    @IBAction
    private func didTapVerifyButton(_ sender: Any) {
        self.viewModel.verifyOTP()
    }
}

extension RedeemOTPViewController: KWTextFieldDelegate {
    
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
            self.view.endEditing(true)
        }
        viewModel.validateOTPString(string: verificationCodeString)
        viewModel.otpCode = verificationCode
    }
}

extension RedeemOTPViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.redeemOTP
    }
}

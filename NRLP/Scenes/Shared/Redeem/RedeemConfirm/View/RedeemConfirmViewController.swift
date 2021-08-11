import UIKit

class RedeemConfirmViewController: BaseViewController {

    var viewModel: RedeemConfirmViewModel!

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

    @IBOutlet private weak var agentCodeField: LabelledTextview! {
        didSet {
            agentCodeField.titleLabelText = "Please enter the code below.".localized
            agentCodeField.placeholderText = "xxxxxx".localized
            agentCodeField.editTextKeyboardType = .asciiCapable
            agentCodeField.onTextFieldChanged = { updatedText in
                self.viewModel.agentCode = updatedText!
            }
            agentCodeField.inputFieldMaxLength = 6
            agentCodeField.formatValidator = FormatValidator(regex: RegexConstants.agentPointsRegex, invalidFormatError: StringConstants.ErrorString.agentCodeError.localized)
        }
    }
    @IBOutlet private weak var headerLabel: UILabel! {
        didSet {
            headerLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
        }
    }

    @IBOutlet private weak var resendLabel: UILabel! {
        didSet {
            resendLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
            resendLabel.textColor = .black
            resendLabel.text = "Code will expire in".localized
        }
    }
    @IBOutlet private weak var resendTime: UILabel! {
        didSet {
            resendTime.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
            resendTime.textColor = .init(commonColor: .appYellow)
            resendTime.text = "05:00"
        }
    }

    @IBOutlet private weak var notReceiveOtpLabel: UILabel!
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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bindViewModelOutput()
        viewModel.viewDidLoad()
    }
    
    override func setupNavigationBackButton() {
        self.navigationItem.hidesBackButton = true
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        viewModel.viewModelWillDisappear()
    }

    private func setupView() {
        self.title = "Redeem".localized
        headerLabel.text = "Please request the agent to input their 6 digit redemption code".localized

        viewModel.viewDidLoad()
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
            case .updateCodeExpireTimer(let timerString):
                self.resendTime.text = timerString
            case .timerEnded:
                let alert = AlertViewModel(alertHeadingImage: .ohSnap, alertTitle: "Oh Snap!".localized, alertDescription: "Code has been expired. Please request for another code.".localized, alertAttributedDescription: nil, primaryButton: AlertActionButtonModel(buttonTitle: "Okay".localized, buttonAction: {
                    self.navigationController?.popToRootViewController(animated: true)
                }), secondaryButton: nil)
                self.showAlert(with: alert)
            case .agentTextField(let errorState, let error):
                self.agentCodeField.updateStateTo(isError: errorState, error: error)
            }
        }
    }

    @IBAction
    private func didTapVerifyButton(_ sender: Any) {
        self.viewModel.validateCode()
    }
}

extension RedeemConfirmViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.redeemConfirm
    }
}

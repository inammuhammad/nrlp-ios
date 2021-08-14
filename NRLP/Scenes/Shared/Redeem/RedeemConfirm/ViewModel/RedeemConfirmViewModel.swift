import Foundation

typealias RedeemConfirmViewModelOutput = (RedeemConfirmViewModel.Output) -> Void

protocol RedeemConfirmViewModelProtocol {
    var output: RedeemConfirmViewModelOutput? { get set}
    var agentCode: String? {get set}
    func viewDidLoad()
    func validateCode()
    func goToSuccess()
    func viewModelWillDisappear()
}

class RedeemConfirmViewModel: RedeemConfirmViewModelProtocol {

    private enum OTPConstants {
        static let otpExpireTimeInterval: Double = 5 * 60
    }

    var output: RedeemConfirmViewModelOutput?

    private var router: RedeemConfirmRouter
    private var service: RedeemService
    private var transactionId: String
    private var partner: Partner
    private var otpExpireTimer: Timer?

    private var otpExpireStartTimerInterval: Date!

    var agentCode: String? {
        didSet {
            validateAgentCode()
        }
    }

    init(with router: RedeemConfirmRouter,
         transactionId: String,
         partner: Partner,
         service: RedeemService = RedeemService()) {

        self.service = service
        self.router = router
        self.transactionId = transactionId
        self.partner = partner
    }

    private func invalidateOTPExpireTimer() {
        otpExpireTimer?.invalidate()
        otpExpireTimer = nil
    }

    func viewModelWillDisappear() {
        invalidateOTPExpireTimer()
    }

    enum Output {
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case nextButtonState(state: Bool)
        case updateCodeExpireTimer(timerString: String)
        case timerEnded
        case agentTextField(errorState: Bool, error: String?)
    }

    func validateCode() {
        if !self.validateDataWithRegex() {
            return
        }
        self.output?(.showActivityIndicator(show: true))

        service.redeemComplete(requestModel: RedeemCompleteRequestModel(transactionId: transactionId, agentCode: agentCode ?? "")) {[weak self] (result) in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                print("response: \(response)")
                self?.goToSuccess()
            case .failure(let error):
                self?.output?(.showError(error: error))
            }
        }
    }

    func goToSuccess() {
        router.goToFinishScreen(transactionId: transactionId, partner: partner)
    }

    private func validateAgentCode() {
        if agentCode?.count == 6 {
            self.output?(.nextButtonState(state: true))
        } else {
            self.output?(.nextButtonState(state: false))
        }

    }

    func viewDidLoad() {
        self.setOtpExpireTimer()
    }

    private func setOtpExpireTimer() {
        invalidateOTPExpireTimer()
        otpExpireStartTimerInterval = Date().addingTimeInterval(OTPConstants.otpExpireTimeInterval)

        otpExpireTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            guard let self = self else { return }

            var timeInterval: TimeInterval = self.otpExpireStartTimerInterval.timeIntervalSince(Date())
            
            if timeInterval <= 0 {
                self.invalidateOTPExpireTimer()
                self.output?(.timerEnded)
                timeInterval = 0
            }
            self.setOTPExpireTimeValue(with: timeInterval)
        })
        otpExpireTimer?.fire()
    }

    private func setOTPExpireTimeValue(with timerInterval: TimeInterval) {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        let formattedTime = (formatter.string(from: timerInterval) ?? "00:00".localized)
        output?(.updateCodeExpireTimer(timerString: formattedTime))
    }

    private func validateDataWithRegex() -> Bool {
        var isValid: Bool = true

        if agentCode?.isValid(for: RegexConstants.agentPointsRegex) ?? false {
            output?(.agentTextField(errorState: false, error: nil))
        } else {
            output?(.agentTextField(errorState: true, error: StringConstants.ErrorString.agentCodeError.localized))
            isValid = false
        }

        return isValid
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

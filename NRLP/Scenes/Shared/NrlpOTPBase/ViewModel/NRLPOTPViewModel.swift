//
//  NRLPOTPViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 28/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias NRLPOTPViewModelOutput = (NRLPOTPViewModel.Output) -> Void

protocol NRLPOTPViewModelProtocol {
    var output: NRLPOTPViewModelOutput? { get set}
    var otpCode: [Int?]? { get set}
    func viewDidLoad()
    func viewModelWillDisappear()
    func didTapOnResendOtpButton()
    func validateOTPString(string: String)
}

class NRLPOTPViewModel: NRLPOTPViewModelProtocol {
    var output: NRLPOTPViewModelOutput?

    private enum OTPConstants {
        static let otpExpireTimeInterval: Double = 5 * 60
        static let resendOtpTimeInterval: Double = 60
        static let resendOTPStartTimeInterval: Double = 10
    }

    private var resendOtpTimer: Timer?
    private var otpExpireTimer: Timer?
    private var resendOtpInfoTimer: Timer?

    private var otpExpireStartTimerInterval: Date!

    internal var retryCount = 1
    private let retryLimit = 3

    var otpCode: [Int?]? {
        didSet {
            hasValidCode()
        }
    }

    enum Output {
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case nextButtonState(state: Bool)
        case resendOtpButtonState(state: Bool)
        case showOTPInvalidFormatError(show: Bool, error: String?)
        case updateCodeExpireTimer(timerString: String)
        case showResendOTPInfoView(show: Bool)
        case showAlert(alertViewModel: AlertViewModel)
    }

    func viewModelWillDisappear() {
        invalidateTimer()
        invalidateInfoStateTimer()
        invalidateOTPExpireTimer()
    }

    private func hasValidCode() {

        var state = true
        if let code = otpCode {
            for value in code where value == nil {

                state = false
            }
            output?(.nextButtonState(state: state))

        } else {
            output?(.nextButtonState(state: false))
        }
    }

    func validateOTPString(string: String) {
        let verifyString = string.trim()
        if verifyString.isValid(for: RegexConstants.otpValidateRegex) {
            output?(.showOTPInvalidFormatError(show: false, error: nil))
        } else {
            output?(.showOTPInvalidFormatError(show: true, error: StringConstants.ErrorString.otpError.localized))
        }
    }

    func getVerificationCode() -> String {

        if let code = otpCode {
            var verificationCode = ""
            for otp in code {
                verificationCode += "\(String(describing: otp ?? 0))"
            }
            return verificationCode
        }
        return ""
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }

    internal func invalidateTimer() {
        resendOtpTimer?.invalidate()
        resendOtpTimer = nil
    }

    private func invalidateInfoStateTimer() {
        resendOtpInfoTimer?.invalidate()
        resendOtpInfoTimer = nil
    }

    private func invalidateOTPExpireTimer() {
        otpExpireTimer?.invalidate()
        otpExpireTimer = nil
    }

    func viewDidLoad() {

        setResendOtpTimer()
        setOtpExpireTimer()
    }

    private func setResendOtpTimer() {
        resendOtpTimer = Timer.scheduledTimer(timeInterval: OTPConstants.resendOtpTimeInterval, target: self, selector: #selector(updateResendOtpState), userInfo: nil, repeats: false)
    }

    internal func setResendOtpInfoTimer() {
        resendOtpInfoTimer = Timer.scheduledTimer(timeInterval: OTPConstants.resendOTPStartTimeInterval, target: self, selector: #selector(updateResendOtpInfoState), userInfo: nil, repeats: false)
    }

    internal func setOtpExpireTimer() {

        invalidateOTPExpireTimer()
        otpExpireStartTimerInterval = Date().addingTimeInterval(OTPConstants.otpExpireTimeInterval)

        otpExpireTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            guard let self = self else { return }

            var timeInterval: TimeInterval = self.otpExpireStartTimerInterval.timeIntervalSince(Date())

            if timeInterval <= 0 {
                self.invalidateOTPExpireTimer()
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

    @objc
    private func updateResendOtpState() {

        output?(.resendOtpButtonState(state: true))
        invalidateTimer()
    }

    @objc
    private func updateResendOtpInfoState() {

        output?(.showResendOTPInfoView(show: false))
        invalidateInfoStateTimer()
    }

    func didTapOnResendOtpButton() {

        output?(.resendOtpButtonState(state: false))
        if retryCount <= retryLimit {
            setResendOtpTimer()
            resendOtpRequest()
        }
    }

    //who ever want to implement give your own implementation
    func resendOtpRequest() {}
}

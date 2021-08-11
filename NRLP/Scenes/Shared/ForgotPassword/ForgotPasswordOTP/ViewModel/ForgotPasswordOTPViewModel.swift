//
//  OTPViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias ForgotPasswordOTPViewModelOutput = (OTPViewModel.Output) -> Void

protocol ForgotPasswordOTPViewModelProtocol: NRLPOTPViewModelProtocol {
    func didTapVerifyButton()
}

class ForgotPasswordOTPViewModel: NRLPOTPViewModel, ForgotPasswordOTPViewModelProtocol {

    private var router: ForgotPasswordOTPRouter
    private var forgotPasswordRequestModel: ForgotPasswordSendOTPRequest
    private let service: ForgotPasswordService

    init(with router: ForgotPasswordOTPRouter,
         forgotPasswordRequestModel: ForgotPasswordSendOTPRequest,
         service: ForgotPasswordService = ForgotPasswordService()) {

        self.router = router
        self.forgotPasswordRequestModel = forgotPasswordRequestModel
        self.service = service
    }

    private func navigateToNewPasswordScreen() {
        router.navigateToNewPasswordScreen(forgotPasswordRequestModel: forgotPasswordRequestModel)
    }

    private func getVerifyOtpRequestModel() -> ForgotPasswordVerifyOTPRequest {

        return ForgotPasswordVerifyOTPRequest(nicNicop: forgotPasswordRequestModel.nicNicop, otp: getVerificationCode(), userType: forgotPasswordRequestModel.userType)
    }

    func didTapVerifyButton() {
        output?(.showActivityIndicator(show: true))
        let requestModel = getVerifyOtpRequestModel()
        service.verifyOTP(requestModel: requestModel) {[weak self] (result) in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                print("Verify OTP Successful: \(response)")
                self?.navigateToNewPasswordScreen()
            case .failure(let error):
                print("Verify OTP Request Fail With Error: \(error)")
                self?.output?(.showError(error: error))

            }
        }
    }
    
    override
    func resendOtpRequest() {

        output?(.showActivityIndicator(show: true))
        service.resendOTP(requestModel: forgotPasswordRequestModel) {[weak self] (result) in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success:
                self?.retryCount += 1
                self?.setOtpExpireTimer()
                self?.output?(.showResendOTPInfoView(show: true))
                self?.setResendOtpInfoTimer()

            case .failure(let error):
                self?.output?(.showError(error: error))
            }
        }
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

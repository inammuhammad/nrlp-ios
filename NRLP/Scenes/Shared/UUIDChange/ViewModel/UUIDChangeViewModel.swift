//
//  UUIDChangeViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

protocol UUIDChangeViewModelProtocol: NRLPOTPViewModelProtocol {
    func didTapVerifyButton()
}

class UUIDChangeViewModel: NRLPOTPViewModel, UUIDChangeViewModelProtocol {

    private var router: UUIDChangeRouter
    private var model: LoginRequestModel
    private let service: LoginServiceProtocol

    init(with router: UUIDChangeRouter,
         model: LoginRequestModel,
         service: LoginServiceProtocol = LoginService()) {
        self.router = router
        self.service = service
        self.model = model
    }

    override
    func getVerificationCode() -> String {
        if let code = otpCode {
            var verificationCode = ""
            for otp in code {
                verificationCode += String(describing: otp ?? 0)
            }
            return verificationCode
        }
        return ""
    }

    func navigateToLoginScreen() {
        router.navigateToLoginScreen()
    }

    func getVerifyOtpRequestModel() -> UUIDUpdateOTPRequestModel {
        return UUIDUpdateOTPRequestModel(accountType: model.accountType, cnicNicop: model.cnicNicop, password: model.paassword, otp: getVerificationCode())
    }

    func didTapVerifyButton() {
        output?(.showActivityIndicator(show: true))
        let requestModel = getVerifyOtpRequestModel()
        service.updateUUID(requestModel: requestModel) {[weak self] (result) in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                print("Verify OTP Successful: \(response)")
                self?.showUuidUpdateAlert()
            case .failure(let error):
                print("Verify OTP Request Fail With Error: \(error)")
                self?.output?(.showError(error: error))
            }
        }
    }
    
    private func showUuidUpdateAlert() {
        let alertViewModel = AlertViewModel(alertHeadingImage: .successFlatAlert, alertTitle: "Device Verified".localized, alertDescription: "Device verified successfully. You will be redirected to Login screen. Please login again.".localized, primaryButton: AlertActionButtonModel(buttonTitle: "Okay".localized, buttonAction: {
            self.navigateToLoginScreen()
        }))
        
        output?(.showAlert(alertViewModel: alertViewModel))
    }

    override
    func resendOtpRequest() {

        output?(.showActivityIndicator(show: true))
        let requestModel = model
        service.resentUUID(requestModel: requestModel) {[weak self] (result) in
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

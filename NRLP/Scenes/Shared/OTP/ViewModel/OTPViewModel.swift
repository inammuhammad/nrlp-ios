//
//  OTPViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

protocol OTPViewModelProtocol: NRLPOTPViewModelProtocol {
    func didTapVerifyButton()
    func getNumber() -> String
    var formattedNumber: String { get }
}

class OTPViewModel: NRLPOTPViewModel, OTPViewModelProtocol {

    private var router: OTPRouter
    private var model: RegisterRequestModel
    private let service: OTPServiceProtocol

    var formattedNumber: String {
        
        var mobileNumber = getNumber()
        if !mobileNumber.hasPrefix("+") {
            return getNumber()
        }
        let prefix = mobileNumber.hasPrefix("+") ? "+" : ""
        
        mobileNumber.removeFirst()
        if AppConstants.appLanguage == .english {
            return "\(prefix)\(mobileNumber)"
        } else {
            return "\(mobileNumber)\(prefix)"
        }
    }
    
    init(with router: OTPRouter,
         model: RegisterRequestModel,
         service: OTPServiceProtocol = OTPService()) {

        self.router = router
        self.model = model
        self.service = service
    }

    private func navigateToTermsScreen() {
        viewModelWillDisappear()
        router.navigateToTermsAndConditionScreen(registerModel: model)
    }

    func getNumber() -> String {
        return model.mobileNo
    }

    override
    func resendOtpRequest() {

        output?(.showActivityIndicator(show: true))
        let requestModel = getResendOtpRequestModel()
        service.resendOtp(requestModel: requestModel) {[weak self] (result) in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                print("Resend OTP Successful: \(response)")
                self?.retryCount += 1
                self?.setOtpExpireTimer()
                self?.output?(.showResendOTPInfoView(show: true))
                self?.setResendOtpInfoTimer()

            case .failure(let error):
                print("Resend OTP Request Fail With Error: \(error)")
                self?.output?(.showError(error: error))
            }
        }
    }

    private func getResendOtpRequestModel() -> ResendOTPRequestModel {

        return ResendOTPRequestModel(nicNicop: model.cnicNicop, retryCount: retryCount, userType: model.accountType)
    }

    private func getVerifyOtpRequestModel() -> VerifyOTPRequestModel {

        return VerifyOTPRequestModel(amount: model.transactionAmount, mobileNo: model.mobileNo, nicNicop: model.cnicNicop, otp: getVerificationCode(), referenceNo: model.transactionRefNo, userType: model.accountType)
    }

    func didTapVerifyButton() {

        output?(.showActivityIndicator(show: true))
        let requestModel = getVerifyOtpRequestModel()
        service.verifyOtp(requestModel: requestModel) {[weak self] (result) in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                print("Verify OTP Successful: \(response)")
                self?.navigateToTermsScreen()
            case .failure(let error):
                print("Verify OTP Request Fail With Error: \(error)")
                self?.output?(.showError(error: error))
            }
        }
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

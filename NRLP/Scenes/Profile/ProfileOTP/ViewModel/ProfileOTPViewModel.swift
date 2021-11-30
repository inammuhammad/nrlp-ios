//
//  ProfileOTPViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

protocol ProfileOTPViewModelProtocol: NRLPOTPViewModel {
    
    var localizedFormattedNumber: String { get }
    
    func didTapVerifyButton()
    func getNumber() -> String
}

class ProfileOTPViewModel: NRLPOTPViewModel, ProfileOTPViewModelProtocol {

    private var router: ProfileOTPRouter
    private let service: UserProfileServiceProtocol
    private var model: ProfileUpdateModel

    var localizedFormattedNumber: String {
        
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
    
    init(with router: ProfileOTPRouter,
         model: ProfileUpdateModel,
         service: UserProfileServiceProtocol = UserProfileService()) {

        self.router = router
        self.model = model
        self.service = service
    }

    func navigateToSuccess() {
        router.navigateToSuccess()
    }
    
    override
    func resendOtpRequest() {

        output?(.showActivityIndicator(show: true))
        let requestModel = getResendOtpRequestModel()
        service.updateUserResendOTP(requestModel: requestModel) {[weak self] (result) in
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
    
    private func getResendOtpRequestModel() -> UpdateProfileSendOTPRequestModel {
        return UpdateProfileSendOTPRequestModel(email: model.profileUpdateRequestModel.email, mobileNumber: model.profileUpdateRequestModel.mobileNumber, passportType: model.profileUpdateRequestModel.passportType, passportNumber: model.profileUpdateRequestModel.passportNumber, residentID: model.profileUpdateRequestModel.residentID, country: model.profileUpdateRequestModel.country)
    }
    
    func getNumber() -> String {
        return model.profileUpdateRequestModel.mobileNumber ?? ((model.userModel.userCountry?.code ?? "0") + (model.userModel.mobileNo ?? ""))
    }
    
    func didTapVerifyButton() {

        output?(.showActivityIndicator(show: true))
        let requestModel = UpdateProfileVerifyOTPRequestModel(mobileNo: model.profileUpdateRequestModel.mobileNumber, email: model.profileUpdateRequestModel.email, otp: getVerificationCode())
        service.updateUserVerifyOTP(requestModel: requestModel) {[weak self] (result) in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                print("Verify ProfileOTP Successful: \(response)")
                self?.navigateToSuccess()
            case .failure(let error):
                print("Verify ProfileOTP Request Fail With Error: \(error)")
                self?.output?(.showError(error: error))
           }
        }
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

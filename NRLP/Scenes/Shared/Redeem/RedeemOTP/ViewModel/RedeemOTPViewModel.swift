//
//  UUIDChangeViewModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//
import Foundation

protocol RedeemOTPViewModelProtocol: NRLPOTPViewModelProtocol {
    var userNumber: String { get }
    var formattedNumber: String { get }
    func verifyOTP()
    func goToAgentConfirmation()
}

class RedeemOTPViewModel: NRLPOTPViewModel, RedeemOTPViewModelProtocol {

    private var router: RedeemOTPRouter
    private var service: RedeemService
    private var transactionId: String
    private var partner: Partner
    private var user: UserModel

    var formattedNumber: String {
        
        var mobileNumber = user.mobileNo ?? ""
        if !mobileNumber.hasPrefix("+") {
            return mobileNumber
        }
        let prefix = mobileNumber.hasPrefix("+") ? "+" : ""
        
        mobileNumber.removeFirst()
        if AppConstants.appLanguage == .english {
            return "\(prefix)\(mobileNumber)"
        } else {
            return "\(mobileNumber)\(prefix)"
        }
    }
    
    var userNumber: String {
        return user.mobileNo ?? ""
    }

    init(with router: RedeemOTPRouter,
         transactionId: String,
         partner: Partner,
         service: RedeemService = RedeemService(),
         user: UserModel) {
        self.service = service
        self.router = router
        self.transactionId = transactionId
        self.partner = partner
        self.user = user
    }

    func verifyOTP() {
        self.output?(.showActivityIndicator(show: true))
        service.verifyOTP(requestModel: RedeemVerifyOTPRequestModel(transactionId:
            transactionId, opt: getVerificationCode())) { [weak self] (result) in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                print("response: \(response)")
                self?.goToAgentConfirmation()
            case .failure(let error):
                self?.output?(.showError(error: error))
            }
        }
    }

    func goToAgentConfirmation() {
        self.router.goToAgentScreen(transactionId: transactionId, partner: partner)
    }

    override
    func resendOtpRequest() {
        output?(.showActivityIndicator(show: true))
        
        service.resendOTP(requestModel: RedeemResentOTPRequestModel(transactionId:
            transactionId)) { [weak self] (result) in
                self?.output?(.showActivityIndicator(show: false))
                
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success:
                self?.setOtpExpireTimer()
                self?.output?(.showResendOTPInfoView(show: true))
                self?.setResendOtpInfoTimer()
                self?.retryCount += 1
                
            case .failure(let error):
                self?.output?(.showError(error: error))
            }
        }
        
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

//
//  RedemptionOTPViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 24/09/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

protocol RedemptionOTPViewModelProtocol: NRLPOTPViewModelProtocol {
    var userNumber: String { get }
    var formattedNumber: String { get }
    func verifyOTP()
}

class RedemptionOTPViewModel: NRLPOTPViewModel, RedemptionOTPViewModelProtocol {

    private var router: RedemptionOTPRouter
    private var service: RedemptionService
    private var transactionId: String
    private var partner: Partner
    private var user: UserModel
    private var inputModel: InitRedemptionTransactionModel
    private var flowType: RedemptionFlowType

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

    init(with router: RedemptionOTPRouter,
         transactionId: String,
         partner: Partner,
         service: RedemptionService = RedemptionService(),
         user: UserModel,
         inputModel: InitRedemptionTransactionModel,
         flowType: RedemptionFlowType) {
        self.service = service
        self.router = router
        self.transactionId = transactionId
        self.partner = partner
        self.user = user
        self.inputModel = inputModel
        self.flowType = flowType
    }

    func verifyOTP() {
        self.output?(.showActivityIndicator(show: true))
        let model = RedeemVerifyOTPRequestModel(transactionId: transactionId, opt: getVerificationCode())
        service.redemptionTransactionVerifyOTP(requestModel: model) { result in
            self.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                self.executeCompleteTransaction(transactionID: self.transactionId)
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        }
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
    
    private func executeCompleteTransaction(transactionID: String) {
        output?(.showActivityIndicator(show: true))
        let model = CompletedRedemptionTransactionModel(transactionId: transactionId)
        service.completeRedemptionTransaction(requestModel: model) { result in
            self.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let model):
                self.router.navigateToSuccessScreen(psid: self.inputModel.consumerNo ?? "", amount: self.inputModel.amount ?? "", flowType: self.flowType, inputModel: self.inputModel, transactionID: self.transactionId)
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        }
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

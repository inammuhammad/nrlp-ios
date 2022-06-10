//
//  SelfAwardOTPViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 28/08/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

protocol SelfAwardOTPViewModelProtocol: NRLPOTPViewModel {
    
    var localizedFormattedNumber: String { get }
    
    func didTapVerifyButton()
    func getNumber() -> String
    
    var formattedNumber: String { get }
}

class SelfAwardOTPViewModel: NRLPOTPViewModel {
    
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

    private let service: SelfAwardOTPServiceProtocol
    private var model: SelfAwardModel
    private weak var navigationController: UINavigationController?
    private var user: UserModel
    private var responseModel: SelfAwardValidateResponseModel
    
    init(model: SelfAwardModel, navigationController: UINavigationController,
         service: SelfAwardOTPService = SelfAwardOTPService(), user: UserModel, responseModel: SelfAwardValidateResponseModel) {

        self.model = model
        self.service = service
        self.navigationController = navigationController
        self.user = user
        self.responseModel = responseModel
    }

    func navigateToSuccess(message: String, customerRating: Bool, nicNicop: String) {
        if let nav = navigationController {
            let vc = OperationCompletedViewController.getInstance()
            vc.viewModel = SelfAwardSuccessViewModel(with: nav, message: message, customerRating: customerRating, nicNicop: nicNicop)
            nav.pushViewController(vc, animated: true)
        }
    }
    
    override
    func resendOtpRequest() {

        output?(.showActivityIndicator(show: true))
        service.validateTransaction(requestModel: getResendOtpRequestModel()) { [weak self] result in
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
    
    private func getResendOtpRequestModel() -> SelfAwardModel {
        self.model.responseTransactionID = self.responseModel.transactionID
        return self.model
    }

    func didTapVerifyButton() {

        output?(.showActivityIndicator(show: true))
        let requestModel = SelfAwardVerifyOTPRequestModel(otp: getVerificationCode(), responseTransactionID: responseModel.transactionID)
        service.verifyOTP(requestModel: requestModel) { [weak self] (result) in
            guard let self = self else {
                return
            }
            
            self.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                self.navigateToSuccess(message: response.message, customerRating: response.customerRating, nicNicop: "\(self.user.cnicNicop)")
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        }
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

struct SelfAwardModel: Codable {
    var amount: String
    var referenceNo: String
    var beneficiaryCnic: String
    var responseTransactionID: String?
    var remittanceDate: String
    var type: String
    
    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case referenceNo = "reference_no"
        case beneficiaryCnic = "beneficiary_nic_nicop"
        case responseTransactionID = "sp_respone_row_id"
        case remittanceDate = "transaction_date"
        case type = "transaction_type"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(amount.aesEncrypted(), forKey: .amount)
        try container.encodeIfPresent(referenceNo.aesEncrypted(), forKey: .referenceNo)
        try container.encodeIfPresent(beneficiaryCnic.aesEncrypted(), forKey: .beneficiaryCnic)
        try container.encodeIfPresent(responseTransactionID?.aesEncrypted(), forKey: .responseTransactionID)
        try container.encodeIfPresent(remittanceDate, forKey: .remittanceDate)
        try container.encodeIfPresent(type, forKey: .type)
    }
}

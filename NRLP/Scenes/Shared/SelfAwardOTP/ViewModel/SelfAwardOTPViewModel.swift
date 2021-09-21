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
}

class SelfAwardOTPViewModel: NRLPOTPViewModel {

    private let service: SelfAwardOTPServiceProtocol
    private var model: SelfAwardModel
    private weak var navigationController: UINavigationController?
    
    init(model: SelfAwardModel, navigationController: UINavigationController,
         service: SelfAwardOTPService = SelfAwardOTPService()) {

        self.model = model
        self.service = service
        self.navigationController = navigationController
    }

    func navigateToSuccess(message: String) {
        if let nav = navigationController {
            let vc = OperationCompletedViewController.getInstance()
            vc.viewModel = SelfAwardSuccessViewModel(with: nav, message: message)
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
        return self.model
    }

    func didTapVerifyButton() {

        output?(.showActivityIndicator(show: true))
        let requestModel = SelfAwardVerifyOTPRequestModel(otp: getVerificationCode())
        service.verifyOTP(requestModel: requestModel) { [weak self] (result) in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                self?.navigateToSuccess(message: response.message)
            case .failure(let error):
                self?.output?(.showError(error: error))
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
    
    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case referenceNo = "reference_no"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(referenceNo.aesEncrypted(), forKey: .referenceNo)
    }
}

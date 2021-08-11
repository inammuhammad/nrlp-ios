//
//  BeneficiaryVerificationViewModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias BeneficiaryVerificationViewModelOutput = (BeneficiaryVerificationViewModel.Output) -> Void

protocol BeneficiaryVerificationViewModelProtocol {

    var output: BeneficiaryVerificationViewModelOutput? { get set}
    func nextButtonPressed()
    var otpCode: [Int?]? { get set}
    func validateOTPString(string: String)
}

class BeneficiaryVerificationViewModel: BeneficiaryVerificationViewModelProtocol {

    private var service: BeneficiaryVerificationServiceProtocol
    private var router: BeneficiaryVerificationRouter
    var output: BeneficiaryVerificationViewModelOutput?
    private var model: RegisterRequestModel
    var otpCode: [Int?]? {
        didSet {
            hasValidCode()
        }
    }

    enum Output {
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case nextButtonState(state: Bool)
        case showOTPInvalidFormatError(show: Bool, error: String?)
    }

    init(service: BeneficiaryVerificationServiceProtocol,
         router: BeneficiaryVerificationRouter,
         model: RegisterRequestModel) {

        self.service = service
        self.router = router
        self.model = model
    }

    func nextButtonPressed() {
        //Registration
        output?(.showActivityIndicator(show: true))
        service.verifyCode(requestModel: VerifyRegistrationCodeRequestModel(nicNicop: model.cnicNicop, registrationCode: getVerificationCode(), userType: model.accountType)) { (result) in
            self.output?(.showActivityIndicator(show: false))
            switch result {
            case .success:
                self.moveToNext()
                //                    self?.router.navigateToNextScreen(model: self.register
            case .failure(let error):
                print("Login Request Fail With Error: \(error)")
                self.output?(.showError(error: error))
            }
        }
    }

    private func moveToNext() {

        model.registrationCode = getVerificationCode()
        router.navigateToNextScreen(registerModel: model)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

extension BeneficiaryVerificationViewModel {

    internal func validateOTPString(string: String) {
        let verifyString = string.trim()
        if verifyString.isValid(for: RegexConstants.otpValidateRegex) {
            output?(.showOTPInvalidFormatError(show: false, error: nil))
        } else {
            output?(.showOTPInvalidFormatError(show: true, error: StringConstants.ErrorString.registrationCodeError.localized))
        }
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

    private func getVerificationCode() -> String {

        if let code = otpCode {
            var verificationCode = ""
            for otp in code {
                verificationCode += "\(String(describing: otp ?? 0))"
            }
            return verificationCode
        }
        return ""
    }
}

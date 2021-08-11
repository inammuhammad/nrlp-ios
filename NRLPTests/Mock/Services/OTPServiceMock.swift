//
//  OTPService.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 10/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class OTPServicePositiveMock: OTPServiceProtocol {

    func verifyOtp(requestModel: VerifyOTPRequestModel, responseHandler: @escaping VerifyRegistrationCodeCallBack) {
        responseHandler(.success(VerifyRegistrationCodeResponseModel(message: "OTP Verified")))
    }

    func resendOtp(requestModel: ResendOTPRequestModel, responseHandler: @escaping ResendVerificationCodeCallBack) {
        responseHandler(.success(ResendOTPResponseModel(message: "OTP Resent")))
    }
}

class OTPServiceNegativeMock: OTPServiceProtocol {

    func verifyOtp(requestModel: VerifyOTPRequestModel, responseHandler: @escaping VerifyRegistrationCodeCallBack) {
        responseHandler(.failure(.internetOffline))
    }

    func resendOtp(requestModel: ResendOTPRequestModel, responseHandler: @escaping ResendVerificationCodeCallBack) {
        responseHandler(.failure(.internetOffline))
    }
}

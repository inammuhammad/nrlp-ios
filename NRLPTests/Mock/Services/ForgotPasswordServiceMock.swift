//
//  ForgotPasswordService.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 22/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class ForgotPasswordServicePositiveMock: ForgotPasswordService {
    override func resendOTP(requestModel: ForgotPasswordSendOTPRequest, responseHandler: @escaping ForgotPasswordSendOTPCallBack) {
        responseHandler(.success(ForgotPasswordSendOTPResponse(message: "A verification code has been sent to your registered mobile number.")))
    }
    
    override func sendOTP(requestModel: ForgotPasswordSendOTPRequest, responseHandler: @escaping ForgotPasswordSendOTPCallBack) {
        responseHandler(.success(ForgotPasswordSendOTPResponse(message: "A verification code has been sent to your registered mobile number.")))
    }

    override func verifyOTP(requestModel: ForgotPasswordVerifyOTPRequest, responseHandler: @escaping ForgotPasswordVerifyOTPCallBack) {
        responseHandler(.success(ForgotPasswordVerifyOTPResponse(message: "OTP Verified successfully")))
    }

    override func updatePassword(requestModel: UpdatePasswordRequest, responseHandler: @escaping UpdatePasswordCallBack) {
        responseHandler(.success(UpdatePasswordResponse(message: "Password Udapted Successfully")))
    }
    
    
}

class ForgotPasswordServiceNegativeMock: ForgotPasswordService {
    override func resendOTP(requestModel: ForgotPasswordSendOTPRequest, responseHandler: @escaping ForgotPasswordSendOTPCallBack) {
        responseHandler(.failure(.internetOffline))
    }
    
    override func sendOTP(requestModel: ForgotPasswordSendOTPRequest, responseHandler: @escaping ForgotPasswordSendOTPCallBack) {
        responseHandler(.failure(.internetOffline))
    }

    override func verifyOTP(requestModel: ForgotPasswordVerifyOTPRequest, responseHandler: @escaping ForgotPasswordVerifyOTPCallBack) {
        responseHandler(.failure(.internetOffline))
    }

    override func updatePassword(requestModel: UpdatePasswordRequest, responseHandler: @escaping UpdatePasswordCallBack) {
        responseHandler(.failure(.internetOffline))
    }
}

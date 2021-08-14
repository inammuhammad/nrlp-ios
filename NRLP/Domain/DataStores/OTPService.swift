//
//  OTPService.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 10/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias VerifyRegistrationCodeCallBack = (Result<VerifyRegistrationCodeResponseModel, APIResponseError>) -> Void
typealias ResendVerificationCodeCallBack = (Result<ResendOTPResponseModel, APIResponseError>) -> Void

protocol OTPServiceProtocol {

    func verifyOtp(requestModel: VerifyOTPRequestModel, responseHandler: @escaping VerifyRegistrationCodeCallBack)
    func resendOtp(requestModel: ResendOTPRequestModel, responseHandler: @escaping ResendVerificationCodeCallBack)
}

class OTPService: BaseDataStore, OTPServiceProtocol {

    func verifyOtp(requestModel: VerifyOTPRequestModel, responseHandler: @escaping VerifyRegistrationCodeCallBack) {

        if !NetworkState.isConnected() {
            responseHandler(.failure(.internetOffline))
            return
        }

   //     responseHandler(.success(VerifyRegistrationCodeResponseModel(message: "otp verified")))

        // request building
        let request = RequestBuilder(path: .init(endPoint: .verifyOTP), parameters: requestModel)

        networking.post(request: request) { (response: APIResponse<VerifyRegistrationCodeResponseModel>) in

            responseHandler(response.result)
        }
    }

    func resendOtp(requestModel: ResendOTPRequestModel, responseHandler: @escaping ResendVerificationCodeCallBack) {

        if !NetworkState.isConnected() {
            responseHandler(.failure(.internetOffline))
            return
        }

       // responseHandler(.success(ResendOTPResponseModel(message: "otp resend")))

        // request building
        let request = RequestBuilder(path: .init(endPoint: .resendOTP), parameters: requestModel)

        networking.post(request: request) { (response: APIResponse<ResendOTPResponseModel>) in

            responseHandler(response.result)
        }
    }
}

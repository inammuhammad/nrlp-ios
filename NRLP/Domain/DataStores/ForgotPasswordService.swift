//
//  ForgotPasswordService.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 22/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias ForgotPasswordSendOTPCallBack = (Result<ForgotPasswordSendOTPResponse, APIResponseError>) -> Void
typealias ForgotPasswordVerifyOTPCallBack = (Result<ForgotPasswordVerifyOTPResponse, APIResponseError>) -> Void
typealias UpdatePasswordCallBack = (Result<UpdatePasswordResponse, APIResponseError>) -> Void

protocol ForgotPasswordServiceProtocol {

    func sendOTP(requestModel: ForgotPasswordSendOTPRequest, responseHandler: @escaping ForgotPasswordSendOTPCallBack)
    func verifyOTP(requestModel: ForgotPasswordVerifyOTPRequest, responseHandler: @escaping ForgotPasswordVerifyOTPCallBack)
    func updatePassword(requestModel: UpdatePasswordRequest, responseHandler: @escaping UpdatePasswordCallBack)
    func resendOTP(requestModel: ForgotPasswordSendOTPRequest, responseHandler: @escaping ForgotPasswordSendOTPCallBack)
}

class ForgotPasswordService: BaseDataStore, ForgotPasswordServiceProtocol {
    func sendOTP(requestModel: ForgotPasswordSendOTPRequest, responseHandler: @escaping ForgotPasswordSendOTPCallBack) {

        if !NetworkState.isConnected() {
            responseHandler(.failure(.internetOffline))
        }

       // responseHandler(.success(ForgotPasswordSendOTPResponse(message: "A verification code has been sent to your registered mobile number.")))

        let request = RequestBuilder(path: .init(endPoint: .forgotPassword), parameters: requestModel)
        networking.post(request: request) { (response: APIResponse<ForgotPasswordSendOTPResponse>) in
            responseHandler(response.result)
        }
    }
    
    func resendOTP(requestModel: ForgotPasswordSendOTPRequest, responseHandler: @escaping ForgotPasswordSendOTPCallBack) {

        if !NetworkState.isConnected() {
            responseHandler(.failure(.internetOffline))
        }

       // responseHandler(.success(ForgotPasswordSendOTPResponse(message: "A verification code has been sent to your registered mobile number.")))

        let request = RequestBuilder(path: .init(endPoint: .resentForgotPasswordOTP), parameters: requestModel)
        networking.post(request: request) { (response: APIResponse<ForgotPasswordSendOTPResponse>) in
            responseHandler(response.result)
        }
    }

    func verifyOTP(requestModel: ForgotPasswordVerifyOTPRequest, responseHandler: @escaping ForgotPasswordVerifyOTPCallBack) {

        if !NetworkState.isConnected() {
            responseHandler(.failure(.internetOffline))
        }

     //   responseHandler(.success(ForgotPasswordVerifyOTPResponse(message: "OTP Verified successfully")))

        let request = RequestBuilder(path: .init(endPoint: .forgotPasswordVerify), parameters: requestModel)
        networking.post(request: request) { (response: APIResponse<ForgotPasswordVerifyOTPResponse>) in
            responseHandler(response.result)
        }
    }

    func updatePassword(requestModel: UpdatePasswordRequest, responseHandler: @escaping UpdatePasswordCallBack) {
        if !NetworkState.isConnected() {
            responseHandler(.failure(.internetOffline))
        }

//        responseHandler(.success(UpdatePasswordResponse(message: "Password Udapted Successfully")))

        let request = RequestBuilder(path: .init(endPoint: .resetPassword), parameters: requestModel)
        networking.post(request: request) { (response: APIResponse<UpdatePasswordResponse>) in
            responseHandler(response.result)
        }
    }
}

//
//  UserProfileService.swift
//  1Link-NRLP
//
//  Created by VenD on 23/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias UserProfileServiceCompletionHandler = (Result<UserProfileResponseModel, APIResponseError>) -> Void
typealias UpdateProfileServiceCompletionHandler = (Result<UpdateProfileSendOTPResponseModel, APIResponseError>) -> Void
typealias UpdateProfileVerifyOTPCompletionHandler = (Result<UpdateProfileVerifyOTPResponseModel, APIResponseError>) -> Void

protocol UserProfileServiceProtocol {

    func getUserProfile(requestModel: UserProfileRequestModel?, responseHandler: @escaping UserProfileServiceCompletionHandler)
    func updateUserSendOTP(requestModel: UpdateProfileSendOTPRequestModel, responseHandler: @escaping UpdateProfileServiceCompletionHandler)
    func updateUserVerifyOTP(requestModel: UpdateProfileVerifyOTPRequestModel?, responseHandler: @escaping UpdateProfileVerifyOTPCompletionHandler)
    func updateUserResendOTP(requestModel: UpdateProfileSendOTPRequestModel, responseHandler: @escaping UpdateProfileServiceCompletionHandler)
    func verifyProfile(requestModel: UpdateProfileVerificationRequestModel, responseHandler: @escaping UpdateProfileVerifyOTPCompletionHandler)
}

extension UserProfileServiceProtocol {
    func getUserProfile(responseHandler: @escaping UserProfileServiceCompletionHandler) {
        return getUserProfile(requestModel: UserProfileRequestModel(), responseHandler: responseHandler)
    }
}

class UserProfileService: BaseDataStore, UserProfileServiceProtocol {
    
    func getUserProfile(requestModel: UserProfileRequestModel?, responseHandler: @escaping UserProfileServiceCompletionHandler) {

//        let response = UserProfileResponseModel(message: "Success", data: UserProfileResponseDataModel(cnicNicop: 4442211247822, fullName: "Rahim", mobileNo: "+923330358315"))

//        responseHandler(.success(response))

        // request building
        let request = RequestBuilder(path: .init(endPoint: .profile), parameters: requestModel, shouldHash: false)

        networking.get(request: request) { (response: APIResponse<UserProfileResponseModel>) in
            responseHandler(response.result)
        }

    }
    
    func updateUserSendOTP(requestModel: UpdateProfileSendOTPRequestModel, responseHandler: @escaping UpdateProfileServiceCompletionHandler) {
        
//        let response = UpdateProfileSendOTPResponseModel(message: "OTP has been sent to registered mobile no")
//        responseHandler(.success(response))
        
        let request = RequestBuilder(path: .init(endPoint: .updateProfileSendOTP), parameters: requestModel)

        networking.post(request: request) { (response: APIResponse<UpdateProfileSendOTPResponseModel>) in
            responseHandler(response.result)
        }
    }
    
    func updateUserResendOTP(requestModel: UpdateProfileSendOTPRequestModel, responseHandler: @escaping UpdateProfileServiceCompletionHandler) {
//        let response = UpdateProfileSendOTPResponseModel(message: "OTP has been sent to registered mobile no")
//        responseHandler(.success(response))
                
        let request = RequestBuilder(path: .init(endPoint: .updateProfileResendOTP), parameters: requestModel)

        networking.post(request: request) { (response: APIResponse<UpdateProfileSendOTPResponseModel>) in
            responseHandler(response.result)
        }
    }
    
    func updateUserVerifyOTP(requestModel: UpdateProfileVerifyOTPRequestModel?, responseHandler: @escaping UpdateProfileVerifyOTPCompletionHandler) {
//        let response = UpdateProfileVerifyOTPResponseModel(message: "Profile updates successfully")
//        responseHandler(.success(response))
        
        let request = RequestBuilder(path: .init(endPoint: .updateProfileVerifyOTP), parameters: requestModel)

        networking.post(request: request) { (response: APIResponse<UpdateProfileVerifyOTPResponseModel>) in
            responseHandler(response.result)
        }
    }
    
    func verifyProfile(requestModel: UpdateProfileVerificationRequestModel, responseHandler: @escaping UpdateProfileVerifyOTPCompletionHandler) {
        let request = RequestBuilder(path: .init(endPoint: .updateProfileVerification), parameters: requestModel)

        networking.post(request: request) { (response: APIResponse<UpdateProfileVerifyOTPResponseModel>) in
            responseHandler(response.result)
        }
    }

}

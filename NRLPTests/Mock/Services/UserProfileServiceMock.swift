//
//  UserProfileServiceMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 26/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class UserProfileServicePositiveMock: UserProfileServiceProtocol {
    
    private var commonUserModel: UserModel
    
    init() {
        commonUserModel = getMockUser()
    }
    
    func getUserProfile(requestModel: UserProfileRequestModel?, responseHandler: @escaping UserProfileServiceCompletionHandler) {
        responseHandler(.success(UserProfileResponseModel(message: "Profile Updated", data: commonUserModel)))
    }
    
    func updateUserSendOTP(requestModel: UpdateProfileSendOTPRequestModel, responseHandler: @escaping UpdateProfileServiceCompletionHandler) {
        responseHandler(.success(UpdateProfileSendOTPResponseModel(message: "OTP has been sent")))
    }
    
    func updateUserVerifyOTP(requestModel: UpdateProfileVerifyOTPRequestModel?, responseHandler: @escaping UpdateProfileVerifyOTPCompletionHandler) {
        responseHandler(.success(UpdateProfileVerifyOTPResponseModel(message: "OTP verification successful")))
    }
    
    func updateUserResendOTP(requestModel: UpdateProfileSendOTPRequestModel, responseHandler: @escaping UpdateProfileServiceCompletionHandler) {
        responseHandler(.success(UpdateProfileSendOTPResponseModel(message: "OTP has been sent")))
    }
}

class UserProfileServiceNegativeMock: UserProfileServiceProtocol {
    
    private var commonUserModel: UserModel
    
    init() {
        commonUserModel = getMockUser()
    }
    
    func getUserProfile(requestModel: UserProfileRequestModel?, responseHandler: @escaping UserProfileServiceCompletionHandler) {
        responseHandler(.failure(.internetOffline))
    }
    
    func updateUserSendOTP(requestModel: UpdateProfileSendOTPRequestModel, responseHandler: @escaping UpdateProfileServiceCompletionHandler) {
        responseHandler(.failure(.internetOffline))
    }
    
    func updateUserVerifyOTP(requestModel: UpdateProfileVerifyOTPRequestModel?, responseHandler: @escaping UpdateProfileVerifyOTPCompletionHandler) {
        responseHandler(.failure(.internetOffline))
    }
    
    func updateUserResendOTP(requestModel: UpdateProfileSendOTPRequestModel, responseHandler: @escaping UpdateProfileServiceCompletionHandler) {
        responseHandler(.failure(.internetOffline))
    }
}

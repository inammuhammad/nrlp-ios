//
//  LoginService.swift
//  NRLPTests
//
//  Created by VenD on 19/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class LoginServicePositiveMock: LoginServiceProtocol {
    func resentUUID(requestModel: LoginRequestModel?, responseHandler: @escaping UUIDUpdateCompletionHandler) {
        responseHandler(.success(UUIDUpdateOTPResponseModel(message: "Success")))
    }
    
    func login(requestModel: LoginRequestModel?, responseHandler: @escaping LoginServiceCompletionHandler) {
        
        var user: UserModel = UserModel()
        user.cnicNicop = 4220133573111
        user.fullName = "Test NRLP"
        user.points = "1234"
        user.mobileNo = "+923428123456"
        user.id = 1
        user.email = "aqib@test.com"
        user.loyaltyType = "bronze"
        user.createdAt = ""
        user.updatedAt = ""
        user.isActive = 1
        user.isDeleted = 0
        
        responseHandler(.success(LoginResponseModel(message: "Success", token: "abcd", user: user, expiresIn: "")))
    }
    
    func updateUUID(requestModel: UUIDUpdateOTPRequestModel?, responseHandler: @escaping UUIDUpdateCompletionHandler) {
        responseHandler(.success(UUIDUpdateOTPResponseModel(message: "Success")))
    }
}

class LoginServiceNegativeMock: LoginServiceProtocol {
    func resentUUID(requestModel: LoginRequestModel?, responseHandler: @escaping UUIDUpdateCompletionHandler) {
        responseHandler(.failure(.unknown))
    }
    
    func login(requestModel: LoginRequestModel?, responseHandler: @escaping LoginServiceCompletionHandler) {
        if requestModel?.accountType == "beneficiary" {
            responseHandler(.failure(.server(ErrorResponse(message: ErrorConstants.deviceNotRegistered.rawValue, errorCode: ErrorConstants.deviceNotRegistered.rawValue))))
        } else {
            responseHandler(.failure(.unknown))
        }
    }
    
    func updateUUID(requestModel: UUIDUpdateOTPRequestModel?, responseHandler: @escaping UUIDUpdateCompletionHandler) {
        responseHandler(.failure(.unknown))
    }
}

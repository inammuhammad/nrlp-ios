//
//  RegisterUserService.swift
//  1Link-NRLP
//
//  Created by VenD on 10/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class RegisterUserServicePositiveMock: RegisterUserService {
    override func registerUser(with requestModel: RegisterRequestModel, completion: @escaping RegisterUserServiceCallBack) {
        completion(.success(RegisterResponseModel(message: "user created successfully")))
    }
}

class RegisterUserServiceNegativeMock: RegisterUserService {
    override func registerUser(with requestModel: RegisterRequestModel, completion: @escaping RegisterUserServiceCallBack) {
        completion(.failure(.internetOffline))
    }
}

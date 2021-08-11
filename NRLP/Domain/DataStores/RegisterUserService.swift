//
//  RegisterUserService.swift
//  1Link-NRLP
//
//  Created by VenD on 10/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias RegisterUserServiceCallBack = (Result<RegisterResponseModel, APIResponseError>) -> Void

protocol RegisterUserServiceProtocol {

    func registerUser(with requestModel: RegisterRequestModel, completion: @escaping RegisterUserServiceCallBack)
}

class RegisterUserService: BaseDataStore, RegisterUserServiceProtocol {
    func registerUser(with requestModel: RegisterRequestModel, completion: @escaping RegisterUserServiceCallBack) {

        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }

     //   completion(.success(RegisterResponseModel(message: "user created successfully")))

        // request building
        let request = RequestBuilder(path: .init(endPoint: .register), parameters: requestModel)

        networking.post(request: request) { (response: APIResponse<RegisterResponseModel>) in

            completion(response.result)
        }
    }
}

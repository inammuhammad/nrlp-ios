//
//  CancelRegisterUserService.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 28/03/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

typealias CancelRegisterUserServiceCallBack = (Result<CancelRegisterResponseModel, APIResponseError>) -> Void

protocol CancelRegisterUserServiceProtocol {

    func cancelRegisterUser(with requestModel: CancelRegisterRequestModel, completion: @escaping CancelRegisterUserServiceCallBack)
}

class CancelRegisterUserService: BaseDataStore, CancelRegisterUserServiceProtocol {
    func cancelRegisterUser(with requestModel: CancelRegisterRequestModel, completion: @escaping CancelRegisterUserServiceCallBack) {

        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }

     //   completion(.success(RegisterResponseModel(message: "user created successfully")))

        // request building
        let request = RequestBuilder(path: .init(endPoint: .cancelRegister), parameters: requestModel)

        networking.post(request: request) { (response: APIResponse<CancelRegisterResponseModel>) in

            completion(response.result)
        }
    }
}


//
//  ChangePasswordService.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 22/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias ChangePasswordCallBack = (Result<ChangePasswordResponseModel, APIResponseError>) -> Void

protocol ChangePasswordServiceProtocol {
    func changePassword(requestModel: ChangePasswordRequestModel, responseHandler: @escaping ChangePasswordCallBack)
}

class ChangePasswordService: BaseDataStore, ChangePasswordServiceProtocol {
    func changePassword(requestModel: ChangePasswordRequestModel, responseHandler: @escaping ChangePasswordCallBack) {
        if !NetworkState.isConnected() {
            responseHandler(.failure(.internetOffline))
        }
//        responseHandler(.success(ChangePasswordResponseModel(message: "You have successfully updated your password.")))

        let request = RequestBuilder(path: APIPathBuilder(endPoint: .changePassword), parameters: requestModel)
        networking.post(request: request) { (response: APIResponse<ChangePasswordResponseModel>) in
            responseHandler(response.result)
        }
    }
}

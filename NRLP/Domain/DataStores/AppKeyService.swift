//
//  AppKeyService.swift
//  NRLP
//
//  Created by Muhammad Usman Tatla on 11/02/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

typealias AppKeyCompletionHandler = (Result<AppKeyResponseModel, APIResponseError>) -> Void

protocol AppKeyServiceProtocol {
    func fetchAppKey(cnic: String, type: AccountType, responseHandler: @escaping AppKeyCompletionHandler)
}

class AppKeyService: BaseDataStore, AppKeyServiceProtocol {
    func fetchAppKey(cnic: String, type: AccountType, responseHandler: @escaping AppKeyCompletionHandler) {
        
        if !NetworkState.isConnected() {
            responseHandler(.failure(.internetOffline))
            return
        }
        
        networking.remove(headerKeys: ["random_key", "user_type", "session_key"])
        var headers: [String: String] = APIRequestHeader().processRequestHeader()
        if let key = RequestKeyGenerator.get32DigitsKey(cnic: cnic, accountType: type) {
            headers["random_key"] = key
            networking.add(headers: headers)
        }
        headers["user_type"] = type.rawValue
        
        let request = RequestBuilder(path: .init(endPoint: .authAppKey), parameters: AppKeyRequestModel(), headers: headers, shouldHash: false)
        print(request)
        networking.get(request: request) { (response: APIResponse<AppKeyResponseModel>) in
            responseHandler(response.result)
        }

    }
}

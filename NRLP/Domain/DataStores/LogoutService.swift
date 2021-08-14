//
//  LogoutService.swift
//  1Link-NRLP
//
//  Created by VenD on 04/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias LogoutServiceCallBack = (Result<LogoutResponseModel, APIResponseError>) -> Void

protocol LogoutServiceProtocol {

    func logoutUser(completion: @escaping LogoutServiceCallBack)
}

class LogoutService: BaseDataStore, LogoutServiceProtocol {
    func logoutUser(completion: @escaping LogoutServiceCallBack) {

        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }

        // request building
        let request = RequestBuilder(path: .init(endPoint: .logout), parameters: LogoutRequestModel(), shouldHash: false)
        networking.get(request: request) { (response: APIResponse<LogoutResponseModel>) in
            if case .success = response.result {
                self.networking.remove(headerKeys: ["Authorization", "session_key"])
            }
            completion(response.result)
        }
    }
}

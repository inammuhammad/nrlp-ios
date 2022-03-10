//
//  BankListingService.swift
//  NRLP
//
//  Created by Bilal Iqbal on 08/03/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

typealias BankListingServiceCallBack = (Result<BankListingResponseModel, APIResponseError>) -> Void

protocol BankListingServiceProtocol {

    func fetchBanks(completion: @escaping BankListingServiceCallBack)
}

class BankListingService: BaseDataStore, BankListingServiceProtocol {
    func fetchBanks(completion: @escaping BankListingServiceCallBack) {

        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }

        let request = RequestBuilder(path: .init(endPoint: .fetchBanks), parameters: EmptyModel(), shouldHash: false)
        
        networking.get(request: request) { (response: APIResponse<BankListingResponseModel>) in
            completion(response.result)
        }
    }
}

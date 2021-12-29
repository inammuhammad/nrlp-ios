//
//  CityService.swift
//  NRLP
//
//  Created by Bilal Iqbal on 28/12/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

typealias CityServiceCallBack = (Result<CitiesResponseModel, APIResponseError>) -> Void

protocol CityServiceProtocol {

    func fetchCities(text: String, page: Int, completion: @escaping CityServiceCallBack)
}

class CityService: BaseDataStore, CityServiceProtocol {
    func fetchCities(text: String, page: Int, completion: @escaping CityServiceCallBack) {
        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }
        
        let request = RequestBuilder(path: .init(endPoint: .cities), parameters: CityRequestModel(text: text.lowercased(), page: page), shouldHash: false)
        
        networking.post(request: request) { (response: APIResponse<CitiesResponseModel>) in
            completion(response.result)
        }
    }
}

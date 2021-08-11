//
//  CountryService.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias CountryServiceCallBack = (Result<CountryCodesResponseModel, APIResponseError>) -> Void

protocol CountryServiceProtocol {

    func fetchCountries(completion: @escaping CountryServiceCallBack)
}

class CountryService: BaseDataStore, CountryServiceProtocol {
    func fetchCountries(completion: @escaping CountryServiceCallBack) {

        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }
//        let countries = [
//            Country(code: "+92", country: "Pakistan", length: "10"),
//            Country(code: "+1", country: "United State Of America", length: "11")
//        ]
//        
//        completion(.success(CountryCodesResponseModel(data: countries, message: "Success")))
//        
//        // request building
        let request = RequestBuilder(path: .init(endPoint: .countryCode), parameters: CountryCodesRequestModel())

        networking.get(request: request) { (response: APIResponse<CountryCodesResponseModel>) in

            completion(response.result)
        }
    }
}

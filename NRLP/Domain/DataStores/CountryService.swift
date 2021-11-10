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

    func fetchCountries(accountType: AccountType?, completion: @escaping CountryServiceCallBack)
}

class CountryService: BaseDataStore, CountryServiceProtocol {
    func fetchCountries(accountType: AccountType?, completion: @escaping CountryServiceCallBack) {

        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }

        let request = RequestBuilder(path: .init(endPoint: .countryCode), parameters: CountryCodesRequestModel(type: accountType?.getTitle().lowercased() ?? ""), shouldHash: false)
        
        networking.post(request: request) { (response: APIResponse<CountryCodesResponseModel>) in
            completion(response.result)
        }

//        networking.get(request: request) { (response: APIResponse<CountryCodesResponseModel>) in
//
//            completion(response.result)
//        }
    }
}

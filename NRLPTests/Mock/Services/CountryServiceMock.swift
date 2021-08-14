//
//  CountryService.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class CountryServicePositiveMock: CountryService {
    override func fetchCountries(completion: @escaping CountryServiceCallBack) {
        
        let commonCountry = [Country(code: "+92", country: "Pakistan", length: 10, id: 1, createdAt: "", updatedAt: "", isActive: 1, isDeleted: 0)]
        
        completion(.success(CountryCodesResponseModel(data: commonCountry, message: "Success")))
    }
    
}

class CountryServiceNegativeMock: CountryService {
    override func fetchCountries(completion: @escaping CountryServiceCallBack) {
        
        completion(.failure(.internetOffline))
    }
    
}

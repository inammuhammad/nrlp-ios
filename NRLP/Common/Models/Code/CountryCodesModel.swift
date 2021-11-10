//
//  CountryCodesModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct CountryCodesResponseModel: Codable {

    let data: [Country]?
    let message: String

}

struct CountryCodesRequestModel: Codable {
    let type: String

    enum CodingKeys: String, CodingKey {
        case type = "type"
    }
}

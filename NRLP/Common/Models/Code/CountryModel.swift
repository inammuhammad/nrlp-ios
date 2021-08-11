//
//  CountryModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct Country: Codable, Equatable {

    let code: String
    let country: String
    let length: Int
    let id: Int
    let createdAt: String
    let updatedAt: String
    let isActive: Int
    let isDeleted: Int

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case country = "country"
        case length = "number_length"
        case id = "id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isActive = "is_active"
        case isDeleted = "is_deleted"
    }

}

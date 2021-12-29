//
//  CityModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 28/12/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

struct CityRequestModel: Codable {
    let text: String
    let page: Int

    enum CodingKeys: String, CodingKey {
        case text = "city"
        case page = "page_number"
    }
}

struct CitiesResponseModel: Codable {
    let data: [Cities]?
    let message: String
}

struct Cities: Codable, Equatable {

    let city: String
    let id: Int
    let createdAt: String
    let updatedAt: String
    let isActive: Int
    let isDeleted: Int

    enum CodingKeys: String, CodingKey {
        case city = "city"
        case id = "id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isActive = "is_active"
        case isDeleted = "is_deleted"
    }

}

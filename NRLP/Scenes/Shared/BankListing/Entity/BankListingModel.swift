//
//  BankListingModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 08/03/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

struct BankListingResponseModel: Codable {

    let data: [Banks]?
    let message: String

}

struct Banks: Codable, Equatable {

    let name: String
    let id: Int
    let createdAt: String
    let updatedAt: String
    let isActive: Int
    let isDeleted: Int

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isActive = "is_active"
        case isDeleted = "is_deleted"
    }

}

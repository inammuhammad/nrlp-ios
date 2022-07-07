//
//  BranchModel.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 06/07/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import Foundation

struct BranchListRequestModel: Codable {
    let pseName: String

    enum CodingKeys: String, CodingKey {
        case pseName = "pse_name"
    }
}

struct BranchListResponseModel: Codable {
    let message: String
    let data: [Branch]
}

struct Branch: Codable {
    let pseName: String
    let id: Int
    let createdAt, countryName: String
    let isDeleted: Int
    let updatedAt: String
    let isActive: Int

    enum CodingKeys: String, CodingKey {
        case pseName = "pse_name"
        case id
        case createdAt = "created_at"
        case countryName = "country_name"
        case isDeleted = "is_deleted"
        case updatedAt = "updated_at"
        case isActive = "is_active"
    }
}

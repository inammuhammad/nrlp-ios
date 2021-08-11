//
//  LoyaltyStatementModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 16/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct FetchLoyaltyStatementRequestModel: Codable {

}

struct FetchLoyaltyAdvanceStatementRequestModel: Codable {
    let email: String
    let fromDate: String
    let toDate: String

    enum CodingKeys: String, CodingKey {
        case email = "email"
        case fromDate = "from_date"
        case toDate = "to_date"
    }
}

struct FetchLoyaltyStatementResponseModel: Codable {
    let data: LoyaltyStatementResponseData
    let message: String
}

struct AdvanceLoyaltyStatementResponseModel: Codable {
    let message: String
}

struct LoyaltyStatementResponseData: Codable {
    let currentpointbalance: String
    let statements: [Statement]

    enum CodingKeys: String, CodingKey {
        case currentpointbalance = "current_points_balance"
        case statements = "statements"
    }
}

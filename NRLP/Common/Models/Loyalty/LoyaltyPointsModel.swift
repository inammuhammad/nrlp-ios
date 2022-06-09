//
//  LoyaltyPointsModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 21/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct LoyaltyPointsRequestModel: Codable {

    let beneficiaryId: Int
    let points: String

    enum CodingKeys: String, CodingKey {
        case beneficiaryId = "beneficiary_id"
        case points = "points"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(beneficiaryId, forKey: .beneficiaryId)
        try container.encodeIfPresent(points.aesEncrypted(), forKey: .points)
    }
}

struct LoyaltyPointsResponseModel: Codable {

    let message: String
    let customerRating: Bool
 
    enum CodingKeys: String, CodingKey {
        case message
        case customerRating = "customer_rating"
    }
}

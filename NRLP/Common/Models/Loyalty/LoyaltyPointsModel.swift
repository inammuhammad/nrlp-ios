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
    let points: Int64

    enum CodingKeys: String, CodingKey {
        case beneficiaryId = "beneficiary_id"
        case points = "points"
    }

}

struct LoyaltyPointsResponseModel: Codable {

    let message: String
   // let points: String
 //   let beneficiary: String

}

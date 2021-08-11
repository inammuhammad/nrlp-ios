//
//  ResendOTPModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct ResendOTPRequestModel: Codable {

    let nicNicop: String!
    let retryCount: Int!
    let userType: String!

    enum CodingKeys: String, CodingKey {
        case nicNicop = "nic_nicop"
        case retryCount = "retry_count"
        case userType = "user_type"
    }

}

struct ResendOTPResponseModel: Codable {

    let message: String!

}

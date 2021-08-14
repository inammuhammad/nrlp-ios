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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nicNicop.aesEncrypted(), forKey: .nicNicop)
        try container.encode(retryCount, forKey: .retryCount)
        try container.encode(userType, forKey: .userType)
    }

}

struct ResendOTPResponseModel: Codable {

    let message: String!

}

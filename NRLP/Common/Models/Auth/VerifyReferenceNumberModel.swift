//
//  VerifyReferenceNumberModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct VerifyReferenceNumberRequestModel: Codable {

    let amount: String
    let mobileNo: String
    let nicNicop: String
    let referenceNo: String
    let userType: String

    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case mobileNo = "mobile_no"
        case nicNicop = "nic_nicop"
        case referenceNo = "reference_no"
        case userType = "user_type"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(amount, forKey: .amount)
        try container.encode(mobileNo, forKey: .mobileNo)
        try container.encode(referenceNo.aesEncrypted(), forKey: .referenceNo)
        try container.encode(userType, forKey: .userType)
        try container.encode(nicNicop.aesEncrypted(), forKey: .nicNicop)
    }

}

struct VerifyReferenceNumberResponseModel: Codable {

    let message: String!
    
}

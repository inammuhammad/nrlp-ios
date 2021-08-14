//
//  VerifyOTPModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct VerifyOTPRequestModel: Codable {

    let amount: String!
    let mobileNo: String!
    let nicNicop: String!
    let otp: String!
    let referenceNo: String!
    let userType: String!

    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case mobileNo = "mobile_no"
        case nicNicop = "nic_nicop"
        case otp = "otp"
        case referenceNo = "reference_no"
        case userType = "user_type"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(amount, forKey: .amount)
        try container.encode(mobileNo, forKey: .mobileNo)
        try container.encode(nicNicop.aesEncrypted(), forKey: .nicNicop)
        try container.encode(otp.aesEncrypted(), forKey: .otp)
        try container.encode(referenceNo.aesEncrypted(), forKey: .referenceNo)
        try container.encode(userType, forKey: .userType)
    }

}

struct VerifyOTPResponseModel: Codable {

    let message: String!

}

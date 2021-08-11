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

}

struct VerifyOTPResponseModel: Codable {

    let message: String!

}

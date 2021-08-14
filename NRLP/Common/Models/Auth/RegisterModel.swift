//
//  RegisterModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct RegisterRequestModel: Codable {

    let accountType: String
    let cnicNicop: String
    let email: String
    let fullName: String
    let mobileNo: String
    let paassword: String
    var registrationCode: String?
    var transactionAmount: String?
    var transactionRefNo: String?

    enum CodingKeys: String, CodingKey {
        case accountType = "user_type"
        case cnicNicop = "nic_nicop"
        case email = "email"
        case fullName = "full_name"
        case mobileNo = "mobile_no"
        case paassword = "password"
        case registrationCode = "registration_code"
        case transactionAmount = "amount"
        case transactionRefNo = "reference_no"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accountType, forKey: .accountType)
        try container.encode(cnicNicop.aesEncrypted(), forKey: .cnicNicop)
        try container.encode(email.aesEncrypted(), forKey: .email)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(mobileNo, forKey: .mobileNo)
        try container.encode(paassword.aesEncrypted(), forKey: .paassword)
        try container.encode(registrationCode?.aesEncrypted(), forKey: .registrationCode)
        try container.encode(transactionAmount, forKey: .transactionAmount)
        try container.encode(transactionRefNo?.aesEncrypted(), forKey: .transactionRefNo)
    }
}

struct RegisterResponseModel: Codable {

    let message: String!

}

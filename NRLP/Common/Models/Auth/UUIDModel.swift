//
//  UUIDModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 23/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct UUIDUpdateOTPRequestModel: Codable {
    let accountType: String
    let cnicNicop: String
    let password: String
    let otp: String

    enum CodingKeys: String, CodingKey {
        case accountType = "user_type"
        case cnicNicop = "nic_nicop"
        case password = "password"
        case otp = "otp"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accountType, forKey: .accountType)
        try container.encode(cnicNicop.aesEncrypted(), forKey: .cnicNicop)
        try container.encode(password.aesEncrypted(), forKey: .password)
        try container.encode(otp.aesEncrypted(), forKey: .otp)
    }
}

struct UUIDUpdateOTPResponseModel: Codable {
    let message: String

}

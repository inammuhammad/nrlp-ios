//
//  VerifyRegistrationCodeModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct VerifyRegistrationCodeRequestModel: Codable {

    let nicNicop: String!
    let registrationCode: String!
    let userType: String!

    enum CodingKeys: String, CodingKey {
        case nicNicop = "nic_nicop"
        case registrationCode = "registration_code"
        case userType = "user_type"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nicNicop.aesEncrypted(), forKey: .nicNicop)
        try container.encode(registrationCode.aesEncrypted(), forKey: .registrationCode)
        try container.encode(userType, forKey: .userType)
    }

}

struct VerifyRegistrationCodeResponseModel: Codable {

    let message: String!

}

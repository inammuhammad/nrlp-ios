//
//  LoginModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct LoginRequestModel: Codable {

    let accountType: String
    let cnicNicop: String
    let paassword: String

    enum CodingKeys: String, CodingKey {
        
        case cnicNicop = "nic_nicop"
        case paassword = "password"
        case accountType = "user_type"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cnicNicop.aesEncrypted(), forKey: .cnicNicop)
        try container.encode(paassword.aesEncrypted(), forKey: .paassword)
        try container.encode(accountType, forKey: .accountType)
    }

}

struct LoginResponseModel: Codable {

    let message: String?
    let token: String?
    var user: UserModel
    let expiresIn: String?
    let sessionKey: String?
    let inActivityTime: String?

    enum CodingKeys: String, CodingKey {
        case expiresIn = "expires_in"
        case message = "message"
        case token = "token"
        case user
        case sessionKey = "session_key"
        case inActivityTime = "in_activity_time"
    }

}

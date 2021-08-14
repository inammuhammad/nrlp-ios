//
//  ForgotPasswordModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 16/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

// Send OTP Related
struct ForgotPasswordSendOTPRequest: Codable {
    let nicNicop: String
    let userType: String

    enum CodingKeys: String, CodingKey {
        case nicNicop = "nic_nicop"
        case userType = "user_type"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nicNicop.aesEncrypted(), forKey: .nicNicop)
        try container.encode(userType, forKey: .userType)
    }
}

struct ForgotPasswordSendOTPResponse: Codable {
    let message: String
}

// Verify OTP Related
struct ForgotPasswordVerifyOTPRequest: Codable {
    let nicNicop: String
    let otp: String
    let userType: String

    enum CodingKeys: String, CodingKey {
        case nicNicop = "nic_nicop"
        case otp = "otp"
        case userType = "user_type"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nicNicop.aesEncrypted(), forKey: .nicNicop)
        try container.encode(otp.aesEncrypted(), forKey: .otp)
        try container.encode(userType, forKey: .userType)
    }
}

struct ForgotPasswordVerifyOTPResponse: Codable {
    let message: String
}

// Update Password Related
struct UpdatePasswordRequest: Codable {
    let nicNicop: String
    let userType: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case nicNicop = "nic_nicop"
        case userType = "user_type"
        case password = "password"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nicNicop.aesEncrypted(), forKey: .nicNicop)
        try container.encode(userType, forKey: .userType)
        try container.encode(password.aesEncrypted(), forKey: .password)
    }
}

struct UpdatePasswordResponse: Codable {
    let message: String
}

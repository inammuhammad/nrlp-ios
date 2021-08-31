//
//  UpdateProfileModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 16/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

// Update profile only
struct UpdateProfileResponseModel: Codable {
    let message: String
}

// Update Profile OTP Service
struct UpdateProfileOTPResponseModel: Codable {
    let message: String
}

// Verify OTP Service
struct UpdateProfileVerifyOTPRequestModel: Codable {
    let mobileNo: String?
    let email: String?
    let otp: String!

    enum CodingKeys: String, CodingKey {
        case mobileNo = "mobile_no"
        case email
        case otp = "otp"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(otp.aesEncrypted(), forKey: .otp)
        try container.encodeIfPresent(email?.aesEncrypted(), forKey: .email)
        try container.encodeIfPresent(mobileNo, forKey: .mobileNo)
    }
}

struct UpdateProfileVerifyOTPResponseModel: Codable {
    let message: String
}

// Update User Profile
struct UpdateProfileRequestModel: Codable {
    let mobileNo: String

    enum CodingKeys: String, CodingKey {
        case mobileNo = "mobile_no"
    }
}

// Update User Profile Send OTP
struct UpdateProfileSendOTPRequestModel: Codable {
    let email: String?
    let mobileNumber: String?
    let passportType: String?
    let passportNumber: String?
    let residentID: String?
    
    enum CodingKeys: String, CodingKey {
        case email
        case mobileNumber = "mobile_no"
        case passportType = "passport_type"
        case passportNumber = "passport_id"
        case residentID = "resident_id"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(email?.aesEncrypted(), forKey: .email)
        try container.encodeIfPresent(mobileNumber, forKey: .mobileNumber)
        try container.encodeIfPresent(passportType, forKey: .passportType)
        try container.encodeIfPresent(passportNumber?.aesEncrypted(), forKey: .passportNumber)
        try container.encodeIfPresent(residentID?.aesEncrypted(), forKey: .residentID)
    }
}

struct UpdateProfileSendOTPResponseModel: Codable {
    let message: String
}


// Verify OTP Service
struct SelfAwardVerifyOTPRequestModel: Codable {

    let otp: String!

    enum CodingKeys: String, CodingKey {

        case otp = "otp"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(otp.aesEncrypted(), forKey: .otp)
    }
}

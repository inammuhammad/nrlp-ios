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
    
    enum CodingKeys: String, CodingKey {
        case email
        case mobileNumber = "mobile_no"
    }
}

struct UpdateProfileSendOTPResponseModel: Codable {
    let message: String
}

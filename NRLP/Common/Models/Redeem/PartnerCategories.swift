//
//  PartnerCategories.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 30/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

// Redeem Initialize Screen
struct PartnerCategoriesRequestModel: Codable {}

struct PartnerCategoriesResponseModel: Codable {
    let message: String
    let data: [Partner]
}

// Redeem Select Service Screen
struct RedeemInitializeRequestModel: Codable {
    let partnerId: String
    let categoryId: String
    let points: Int

    enum CodingKeys: String, CodingKey {
        case partnerId = "partner_id"
        case categoryId = "category_id"
        case points = "points"
    }
}

struct RedeemInitializeResponseModel: Codable {
    let message: String
    let transactionId: String

    enum CodingKeys: String, CodingKey {
        case transactionId = "transaction_id"
        case message
    }
}

// Redeem OTP Screen
struct RedeemVerifyOTPRequestModel: Codable {
    let transactionId: String
    let opt: String

    enum CodingKeys: String, CodingKey {
        case transactionId = "transaction_id"
        case opt = "otp"
    }
}

// Redeem OTP Screen
struct RedeemResentOTPRequestModel: Codable {
    let transactionId: String

    enum CodingKeys: String, CodingKey {
        case transactionId = "transaction_id"
    }
}

struct RedeemVerifyOTPResponseModel: Codable {
    let message: String
}

// Redeem Agent Code Screen
struct RedeemCompleteRequestModel: Codable {
    let transactionId: String
    let agentCode: String

    enum CodingKeys: String, CodingKey {
        case transactionId = "transaction_id"
        case agentCode = "agent_code"
    }
}

struct RedeemCompleteResponseModel: Codable {
    let message: String
    let transactionId: String

    enum CodingKeys: String, CodingKey {
        case transactionId = "transaction_id"
        case message
    }
}

//
//  RedeemLoyalty.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 24/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

// Partners
struct RedeemLoyaltyPartnersRequestModel: Codable {}

struct RedeemLoyaltyPartnersResponseModel: Codable {

    let data: [LoyaltyPartner]

}

// Services
struct RedeemLoyaltyServiceRequestModel: Codable {

    let partnerId: String
    enum CodingKeys: String, CodingKey {
        case partnerId = "partner_id"
    }
}

struct RedeemLoyaltyServiceResponseModel: Codable {

    let points: Int
    let data: [LoyaltyService]

    enum CodingKeys: String, CodingKey {
        case data
        case points
    }
}

// Get OTP
struct RedeemLoyaltyGetOTPRequestModel: Codable {

    let partnerId: String
    let serviceId: String

    enum CodingKeys: String, CodingKey {
        case partnerId = "partner_id"
        case serviceId = "service_id"
    }
}

struct RedeemLoyaltyGetOTPResponseModel: Codable {

    let message: String

    enum CodingKeys: String, CodingKey {
        case message
    }
}

// Verify OTP
struct RedeemLoyaltyVerifyOTPRequestModel: Codable {

    let partnerId: String
    let serviceId: String
    let otp: String

    enum CodingKeys: String, CodingKey {
        case partnerId = "partner_id"
        case serviceId = "service_id"
        case otp = "opt"
    }
}

struct RedeemLoyaltyVerifyOTPResponseModel: Codable {

    let message: String
    let transactionId: String

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case transactionId = "transaction_id"
    }
}

struct RedeemLoyaltyVerifyAgentCodeRequestModel: Codable {

    let partnerId: String
    let serviceId: String
    let transactionId: String
    let agenctCode: String

    enum CodingKeys: String, CodingKey {
        case partnerId = "partner_id"
        case serviceId = "service_id"
        case transactionId = "transaction_id"
        case agenctCode = "agent_code"
    }
}

struct RedeemVerifyAgentCodeResponseModel: Codable {

    let message: String

    enum CodingKeys: String, CodingKey {
        case message
    }
}

//
//  InitRedemptionTransactionModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 24/09/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

struct InitRedemptionTransactionModel: Codable {
    var code: String
    var pse: String
    var consumerNo: String?
    var amount: String?
    var sotp: Int?
    var pseChild: String?
    var mobileNo: String?
    var email: String?
    var trackingID: String?
    var point: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case pse = "pse"
        case consumerNo = "consumer_no"
        case amount = "amount"
        case sotp = "sotp"
        case pseChild = "pse_child"
        case mobileNo = "mobile_no"
        case email = "email"
        case trackingID = "tracking_id"
        case point = "point"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(code, forKey: .code)
        try container.encodeIfPresent(pse, forKey: .pse)
        try container.encodeIfPresent(consumerNo, forKey: .consumerNo)
        try container.encodeIfPresent(amount?.aesEncrypted(), forKey: .amount)
        try container.encodeIfPresent(sotp, forKey: .sotp)
        try container.encodeIfPresent(pseChild, forKey: .pseChild)
        try container.encodeIfPresent(mobileNo, forKey: .mobileNo)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(trackingID, forKey: .trackingID)
        try container.encodeIfPresent(point, forKey: .point)
    }
}

struct CompletedRedemptionTransactionModel: Codable {
    let transactionId: String
    
    enum CodingKeys: String, CodingKey {
        case transactionId = "transaction_id"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(transactionId, forKey: .transactionId)
    }
}

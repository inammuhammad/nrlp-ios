//
//  CSREntity.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 09/06/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import Foundation

// MARK: Data Store
enum CSRTransactionType: String {
    case transferPoints = "transfer-point"
    case selfAward = "self-award"
    case registration = "registration"
}

struct CSRModel {
    var nicNicop: String?
    var userType: String?
    var transactionId: String?
    var transactionType: CSRTransactionType?
}

// MARK: Post Login
struct CSRRequestModel: Codable {
    var nicNicop: String
    var transactionId: String
    var transactionType: String
    var comments: String
    
    enum CodingKeys: String, CodingKey {
        case nicNicop = "nic_nicop"
        case transactionId = "transaction_id"
        case transactionType = "transaction_type"
        case comments
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nicNicop.aesEncrypted(), forKey: .nicNicop)
        try container.encode(transactionId, forKey: .transactionId)
        try container.encode(transactionType, forKey: .transactionType)
        try container.encode(comments, forKey: .comments)
    }
}

struct CSRResponseModel: Codable {
    let message: String

    enum CodingKeys: String, CodingKey {
        case message
    }
}

// MARK: Registration
struct RegistrationCSRRequestModel: Codable {
    var nicNicop: String
    var userType: String
    var transactionType: String
    var comments: String
    
    enum CodingKeys: String, CodingKey {
        case nicNicop = "nic_nicop"
        case userType = "user_type"
        case transactionType = "transaction_type"
        case comments
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nicNicop.aesEncrypted(), forKey: .nicNicop)
        try container.encode(userType, forKey: .userType)
        try container.encode(transactionType, forKey: .transactionType)
        try container.encode(comments, forKey: .comments)
    }
}

struct RegistrationCSRResponseModel: Codable {
    let message: String

    enum CodingKeys: String, CodingKey {
        case message
    }
}

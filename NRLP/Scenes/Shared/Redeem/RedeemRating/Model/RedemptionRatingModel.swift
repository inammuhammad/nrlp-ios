//
//  RedemptionRatingModel.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 13/04/2022.
//

import Foundation

struct RedemptionRatingModel: Codable {
    let transactionId: String
    let comments: String

    enum CodingKeys: String, CodingKey {
        case transactionId = "transaction_id"
        case comments = "comments"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(transactionId, forKey: .transactionId)
        try container.encode(comments, forKey: .comments)
    }
}

typealias RedemptionRatingCallback = (Result<RedemptionRatingResponseModel, APIResponseError>) -> Void

struct RedemptionRatingResponseModel: Codable {
    let message: String

    enum CodingKeys: String, CodingKey {
        case message
    }
}

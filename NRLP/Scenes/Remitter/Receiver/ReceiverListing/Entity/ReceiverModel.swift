//
//  ReceiverModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 22/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

struct ReceiverModel: Codable {

    var alias: String?
    let beneficiaryId: Int64
    let isActive: Int
    let mobileNo: String
    let nicNicop: Int
    let createdAt: String
    let updatedAt: String
    let isDeleted: Int
    let beneficiaryRelation: String
    let country: String?
    let receiverTypeString: String?
    var receiverType: RemitterReceiverType? {
        RemitterReceiverType(rawValue: receiverTypeString ?? "")
    }

    var formattedCNIC: String {
        return CNICFormatter().format(string: "\(nicNicop)")
    }
    
    var updateAtTime: Date? {
        let time = DateFormat().formatDate(dateString: updatedAt, formatter: .dateTimeMilis)
        return time?.adding(hours: 5)
    }

    enum CodingKeys: String, CodingKey {
        case alias = "alias"
        case beneficiaryId = "id"
        case mobileNo = "mobile_no"
        case nicNicop = "nic_nicop"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isActive = "is_active"
        case isDeleted = "is_deleted"
        case beneficiaryRelation = "relationship"
        case country = "country"
        case receiverTypeString = "receiver_type"
    }

}

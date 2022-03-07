//
//  ReceiverModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 22/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

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

struct AddReceiverRequestModel: Codable {

    let cnic: String?
    let mobileNo: String?
    let fullName: String?
    let motherMaidenName: String?
    let cnicIssueDate: String?
    let birthPlace: String?
    let bankAccountNumber: String?
    let bankName: String?
    
    enum CodingKeys: String, CodingKey {
        case cnic = "nic_nicop"
        case mobileNo = "mobile_no"
        case fullName = "full_name"
        case motherMaidenName = "mother_maiden_name"
        case cnicIssueDate = "cnic_nicop_issuance_date"
        case birthPlace = "place_of_birth"
        case bankAccountNumber = "account_number_iban"
        case bankName = "bank_name"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(cnic?.aesEncrypted(), forKey: .cnic)
        try container.encodeIfPresent(mobileNo, forKey: .mobileNo)
        try container.encodeIfPresent(fullName, forKey: .fullName)
        try container.encodeIfPresent(motherMaidenName?.aesEncrypted(), forKey: .motherMaidenName)
        try container.encodeIfPresent(cnicIssueDate?.aesEncrypted(), forKey: .cnicIssueDate)
        try container.encodeIfPresent(birthPlace?.aesEncrypted(), forKey: .birthPlace)
        try container.encodeIfPresent(bankAccountNumber?.aesEncrypted(), forKey: .bankAccountNumber)
        try container.encodeIfPresent(bankName?.aesEncrypted(), forKey: .bankName)
    }
}

struct AddReceiverResponseModel: Codable {
    let message: String
}

struct DeleteReceiverRequestModel: Codable {

    let cnic: String?
    
    enum CodingKeys: String, CodingKey {
        case cnic = "nic_nicop"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(cnic?.aesEncrypted(), forKey: .cnic)
    }
}

struct DeleteReceiverResponseModel: Codable {
    let message: String
}

struct ReceiverListResponseModel: Codable {
    let message: String
    let data: [ReceiverModel]
}

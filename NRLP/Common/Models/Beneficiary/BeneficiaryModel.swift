//
//  BeneficiaryModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct BeneficiaryModel: Codable {

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

    var formattedCNIC: String {
        return CNICFormatter().format(string: "\(nicNicop)")
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
    }

}

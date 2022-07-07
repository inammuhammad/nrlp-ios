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
    let nadraStatusCode: String?

    var formattedCNIC: String {
        if nicNicop != 0 {
            var cnic = "\(nicNicop)"
            
            if cnic.count < 13 {
                cnic = String(repeating: "0", count: 13 - cnic.count) + cnic
            }
            
            return CNICFormatter().format(string: cnic)
        }
        return CNICFormatter().format(string: "")
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
        case nadraStatusCode = "nadra_status_code"
    }

}

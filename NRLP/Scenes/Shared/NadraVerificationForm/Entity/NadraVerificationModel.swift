//
//  NadraVerificationModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 04/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

struct NadraVerificationRequestModel: Codable {
    let motherMaidenName: String?
    let fullName: String?
    let cnicIssueDate: String?
    let birthPlace: String?
    
    enum CodingKeys: String, CodingKey {
        case motherMaidenName = "mother_maiden_name"
        case fullName = "full_name"
        case cnicIssueDate = "cnic_nicop_issuance_date"
        case birthPlace = "place_of_birth"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(motherMaidenName?.aesEncrypted(), forKey: .motherMaidenName)
        try container.encodeIfPresent(fullName, forKey: .fullName)
        try container.encodeIfPresent(birthPlace?.aesEncrypted(), forKey: .birthPlace)
        try container.encodeIfPresent(cnicIssueDate?.aesEncrypted(), forKey: .cnicIssueDate)
    }
}

struct NadraVerificationResponseModel: Codable {
    let message: String
}

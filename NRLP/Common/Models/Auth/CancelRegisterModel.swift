//
//  CancelRegisterModel.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 28/03/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

struct CancelRegisterRequestModel: Codable {

    let accountType: String
    let cnicNicop: String
    let versionNo: String
    let tncId: Int

    enum CodingKeys: String, CodingKey {
        case accountType = "user_type"
        case cnicNicop = "nic_nicop"
        case versionNo = "version_no"
        case tncId = "term_condition_id"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accountType, forKey: .accountType)
        try container.encode(cnicNicop.aesEncrypted(), forKey: .cnicNicop)
        try container.encode(versionNo, forKey: .versionNo)
        try container.encode(tncId, forKey: .tncId)
    }
}

struct CancelRegisterResponseModel: Codable {
    let message: String!
}


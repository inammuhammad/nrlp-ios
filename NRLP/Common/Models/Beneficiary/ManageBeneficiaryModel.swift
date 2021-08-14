//
//  ManageBeneficiaryModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct ManageBeneficiaryRequestModel: Codable {

    let nicNicop: String
    let accountType: String

    enum CodingKeys: String, CodingKey {
        case nicNicop = "nic_nicop"
        case accountType = "account_type"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nicNicop.aesEncrypted(), forKey: .nicNicop)
        try container.encode(accountType, forKey: .accountType)
    }
}

struct ManageBeneficiaryResponseModel: Codable {

    let data: [BeneficiaryModel]
    let message: String

}

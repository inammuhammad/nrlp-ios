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
}

struct ManageBeneficiaryResponseModel: Codable {

    let data: [BeneficiaryModel]
    let message: String

}

//
//  UpdateBeneficiaryModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 21/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

struct UpdateBeneficiaryRequestModel: Codable {
    
    let beneficiaryID: String?
    let beneficiaryName: String?
    let beneficiaryMobileNo: String?
    let beneficiaryNicNicop: String?
    let beneficiaryRelation: String?
    let beneficiaryCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case beneficiaryID = "beneficiary_id"
        case beneficiaryName = "full_name"
        case beneficiaryMobileNo = "mobile_no"
        case beneficiaryNicNicop = "nic_nicop"
        case beneficiaryRelation = "relationship"
        case beneficiaryCountry = "country"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(beneficiaryID, forKey: .beneficiaryID)
        try container.encodeIfPresent(beneficiaryMobileNo, forKey: .beneficiaryMobileNo)
        try container.encodeIfPresent(beneficiaryNicNicop?.aesEncrypted(), forKey: .beneficiaryNicNicop)
        try container.encodeIfPresent(beneficiaryRelation, forKey: .beneficiaryRelation)
        try container.encodeIfPresent(beneficiaryCountry, forKey: .beneficiaryCountry)
        try container.encodeIfPresent(beneficiaryName, forKey: .beneficiaryName)
    }
}

struct UpdateBeneficiaryResponseModel: Codable {
    
    let message: String
    
}

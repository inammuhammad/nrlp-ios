//
//  AddBeneficiaryModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct AddBeneficiaryRequestModel: Codable {

   let beneficiaryAlias: String?
   let beneficiaryMobileNo: String?
   let beneficiaryNicNicop: String?
    let beneficiaryRelation: String?

   enum CodingKeys: String, CodingKey {
       case beneficiaryAlias = "beneficiary_alias"
       case beneficiaryMobileNo = "beneficiary_mobile_no"
       case beneficiaryNicNicop = "beneficiary_nic_nicop"
        case beneficiaryRelation = "beneficiary_relationship"
   }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(beneficiaryAlias, forKey: .beneficiaryAlias)
        try container.encodeIfPresent(beneficiaryMobileNo, forKey: .beneficiaryMobileNo)
        try container.encodeIfPresent(beneficiaryNicNicop?.aesEncrypted(), forKey: .beneficiaryNicNicop)
        try container.encodeIfPresent(beneficiaryRelation, forKey: .beneficiaryRelation)
    }
}

struct AddBeneficiaryResponseModel: Codable {

    let message: String

}

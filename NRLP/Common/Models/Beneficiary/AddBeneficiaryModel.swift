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

   enum CodingKeys: String, CodingKey {
       case beneficiaryAlias = "beneficiary_alias"
       case beneficiaryMobileNo = "beneficiary_mobile_no"
       case beneficiaryNicNicop = "beneficiary_nic_nicop"
   }
}

struct AddBeneficiaryResponseModel: Codable {

    let message: String

}

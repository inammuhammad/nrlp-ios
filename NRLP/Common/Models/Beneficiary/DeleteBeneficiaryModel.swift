//
//  DeleteBeneficiaryModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct DeleteBeneficiaryRequestModel: Codable {

    let beneficiaryId: Int64

    enum CodingKeys: String, CodingKey {
        case beneficiaryId = "beneficiary_id"
    }

}

struct DeleteBeneficiaryResponseModel: Codable {

    let message: String

}

//
//  ResendOTPBeneficiaryModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 21/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

struct ResendOTPBeneficiaryRequestModel: Codable {
    
    let beneficiaryID: String?
    
    enum CodingKeys: String, CodingKey {
        case beneficiaryID = "beneficiary_id"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(beneficiaryID, forKey: .beneficiaryID)
    }
}

struct ResendOTPBeneficiaryResponseModel: Codable {
    
    let message: String
    
}

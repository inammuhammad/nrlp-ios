//
//  NRLPBenefitResponseModel.swift
//  NRLP
//
//  Created by VenD on 02/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct NRLPBenefitResponseModel: Codable {
    var message: String
    var data: RedemptionPartners
}

struct NRLPBenefitCategoryResponseModel: Codable {
    var message: String
    var data: NRLPBenefitPartnerCatalog
}

struct NRLPBenefitPartnerCatalog: Codable {
    var partnerCatalogs: [NRLPBenefitCategory]
    enum CodingKeys: String, CodingKey {
        case partnerCatalogs = "partner_catalogs"
        
    }
}

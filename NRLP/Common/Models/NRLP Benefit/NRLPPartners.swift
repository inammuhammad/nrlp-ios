//
//  NRLPPartners.swift
//  NRLP
//
//  Created by VenD on 02/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct RedemptionPartners: Codable {
    var redemptionPartners: [NRLPPartners]
    enum CodingKeys: String, CodingKey {
        case redemptionPartners = "redemption_partners"
    }
}

struct NRLPPartners: Codable {
    var name: String
    var imageSrc: String
    var id: Int
    
    enum CodingKeys: String, CodingKey {
        case name, id
        case imageSrc = "img_src"
        
    }
}

struct NRLPBenefitCategory: Codable {
    var name: String
}

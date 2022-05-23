//
//  Partner.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 30/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct Partner: Codable {
    let id: Int
    var partnerName: String
    let categories: [Category]
    var categoryCount: Int {
        return categories.count
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case partnerName = "partner_name"
        case categories = "categories"
    }
}

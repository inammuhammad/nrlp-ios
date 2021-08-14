//
//  Category.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 30/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct Category: Codable {
    let id: Int
    let categoryName: String
    let pointsAssigned: Int

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case categoryName = "catalog_name"
        case pointsAssigned = "points_assigned"
    }
}

//
//  LoyaltyService.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 27/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct LoyaltyService: Codable {

    let name: String
    let points: Int
    var formattedPoints: String {
        let formater = CurrencyFormatter()
        return formater.format(string: "\(points)")
    }

}

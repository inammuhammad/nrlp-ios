//
//  NadraTypes.swift
//  NRLP
//
//  Created by Bilal Iqbal on 03/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

enum NadraTypes: String {
    case pending = "PENDING"
    case verified = "VERIFIED"
    case notVerified = "NOT-VERIFIED"
    case blackListed = "BLACKLISTED"
    case registered = "REGISTERED"
    
    static func fromRaw(raw: String) -> NadraTypes {
        NadraTypes(rawValue: raw) ?? .pending
    }
}

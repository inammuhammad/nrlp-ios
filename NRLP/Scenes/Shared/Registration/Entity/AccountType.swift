//
//  AccountType.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

enum AccountType: String {
    case remitter
    case beneficiary

    func getTitle() -> String {
        switch self {
        case .remitter:
            return "Remitter".localized
        case .beneficiary:
            return "Beneficiary".localized
        }
    }
    
    static func fromRaw(raw: String) -> AccountType {
        AccountType(rawValue: raw) ?? .remitter
    }
}

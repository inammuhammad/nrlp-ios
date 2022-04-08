//
//  TransactionType.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 06/04/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

enum TransactionType: String {
    case cnic
    case bank

    func getTitle() -> String {
        switch self {
        case .cnic:
            return "Remittance sent to CNIC".localized
        case .bank:
            return "Remittance sent to Bank Account".localized
        }
    }
    
    static func fromRaw(raw: String) -> TransactionType {
        TransactionType(rawValue: raw) ?? .cnic
    }
}

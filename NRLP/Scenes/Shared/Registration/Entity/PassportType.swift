//
//  PassportType.swift
//  NRLP
//
//  Created by Bilal Iqbal on 10/08/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

enum PassportType: String {
    case international = "International Passport"
    case pakistani = "Pakistani Passport"

    func getTitle() -> String {
        switch self {
        case .international:
            return "International Passport".localized
        case .pakistani:
            return "Pakistani Passport".localized
        }
    }
}

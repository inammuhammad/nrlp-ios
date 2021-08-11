//
//  AppLanguage.swift
//  1Link-NRLP
//
//  Created by VenD on 11/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

enum AppLanguage: String {
    case english = "en"
    case urdu = "ur"
    
    var title: String {
        switch self {
        case .english:
            return "English".localized
        case .urdu:
            return "Urdu".localized
        }
    }
}

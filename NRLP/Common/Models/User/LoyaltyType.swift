//
//  LoyaltyType.swift
//  1Link-NRLP
//
//  Created by VenD on 08/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

enum LoyaltyType: String, Codable {
    case green
    case bronze
    case gold
    case platinum
    
    var cardImage: UIImage? {
        switch self {
        case .bronze, .green:
            return #imageLiteral(resourceName: "greenCard")
        case .gold:
            return #imageLiteral(resourceName: "goldCard")
        case .platinum:
            return #imageLiteral(resourceName: "platinumCard")
        }
    }
    
    var title: String {
        switch self {
        case .bronze, .green:
            return "Green"
        case .gold:
            return "Gold"
        case .platinum:
            return "Platinum"
        }
    }
    
    var themeColor: CommonColor {
        switch self {
        case .bronze, .green:
            return CommonColor.appLoyaltyThemeBronze
        case .gold:
            return CommonColor.appLoyaltyThemeGold
        case .platinum:
            return CommonColor.appLoyaltyThemePlatinum
        }
    }
}

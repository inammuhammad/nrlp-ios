//
//  LoyaltyType.swift
//  1Link-NRLP
//
//  Created by VenD on 08/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

enum LoyaltyType: String, Codable {
    case bronze
    case silver
    case gold
    case platinum
    
    var gradientColor: (light: CommonColor, dark: CommonColor) {
        switch self {
        case .bronze:
            return (CommonColor.appLoyaltyGradientLightBronze, CommonColor.appLoyaltyGradientDarkBronze)
        case .silver:
            return (CommonColor.appLoyaltyGradientLightSilver, CommonColor.appLoyaltyGradientDarkSilver)
        case .gold:
            return (CommonColor.appLoyaltyGradientLightGold, CommonColor.appLoyaltyGradientDarkGold)
        case .platinum:
            return (CommonColor.appLoyaltyGradientLightPlatinum, CommonColor.appLoyaltyGradientDarkPlatinum)
        }
    }
    
    var title: String {
        switch self {
        case .bronze:
            return "Bronze"
        case .silver:
            return "Silver"
        case .gold:
            return "Gold"
        case .platinum:
            return "Platinum"
        }
    }
    
    var themeColor: CommonColor {
        switch self {
        case .bronze:
            return CommonColor.appLoyaltyThemeBronze
        case .silver:
            return CommonColor.appLoyaltyThemeSilver
        case .gold:
            return CommonColor.appLoyaltyThemeGold
        case .platinum:
            return CommonColor.appLoyaltyThemePlatinum
        }
    }
}

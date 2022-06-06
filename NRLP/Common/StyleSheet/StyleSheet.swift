//
//  StyleSheet.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

public enum CommonColor {
    
    case appBlue
    case appGreen
    case appBottomBorderViewShadow
    case appLightGray
    case appErrorRed
    case appDarkGray
    case appYellow
    case disableGery
    
    case appInactiveBg
    case appInactiveText
    case appActiveBg
    case appActiveText
    case appRedeemBg
    case appRedeemText
    
    case appBackgroundDarkOverlay
    case appTransparentGreen
    
    case appLoyaltyGradientLightBronze
    case appLoyaltyGradientDarkBronze
    case appLoyaltyThemeBronze
    
    case appLoyaltyGradientLightSilver
    case appLoyaltyGradientDarkSilver
    case appLoyaltyThemeSilver
    
    case appLoyaltyGradientLightGold
    case appLoyaltyGradientDarkGold
    case appLoyaltyThemeGold
    
    case appLoyaltyGradientLightPlatinum
    case appLoyaltyGradientDarkPlatinum
    case appLoyaltyThemePlatinum
    
    case appLoyaltyGradientLight
    case appLoyaltyGradientDark
    
    case appRedemptionRatingYellow
    case appRedemptionRatingGray
    
    case appNotificationGray
    
    var rgba: [CGFloat] {
        switch self {
        case .appBlue: return colorInfoWith(red: 31.0, green: 135.0, blue: 229.0)
        case .appBottomBorderViewShadow: return colorInfoRgbDividedWith(red: 0, green: 0, blue: 0, alpha: 0.13)
        case .appGreen: return colorInfoWith(red: 1, green: 77, blue: 39, alpha: 1)
        case .appLightGray: return colorInfoWith(red: 218, green: 218, blue: 218, alpha: 1)
        case .appErrorRed: return colorInfoWith(red: 158, green: 31, blue: 23, alpha: 1)
        case .appDarkGray: return colorInfoWith(red: 24, green: 24, blue: 24, alpha: 1)
        case .appYellow: return colorInfoWith(red: 0.99 * 255, green: 0.64 * 255, blue: 0, alpha: 1)
        case .disableGery: return colorInfoWith(red: 139, green: 139, blue: 139, alpha: 1)
            
        case .appInactiveBg: return colorInfoWith(red: 255, green: 246, blue: 229, alpha: 1)
        case .appInactiveText: return colorInfoWith(red: 253, green: 164, blue: 0, alpha: 1)
        case .appActiveBg: return colorInfoWith(red: 230, green: 237, blue: 233, alpha: 1)
        case .appActiveText: return colorInfoWith(red: 1, green: 77, blue: 39, alpha: 1)
            
        case .appBackgroundDarkOverlay: return colorInfoWith(red: 24, green: 24, blue: 24, alpha: 0.5)
        case .appRedeemBg: return colorInfoWith(red: 245, green: 233, blue: 232, alpha: 1)
        case .appRedeemText: return colorInfoWith(red: 158, green: 31, blue: 23, alpha: 1)
        case .appTransparentGreen: return colorInfoWith(red: 1, green: 77, blue: 39, alpha: 0.1)
            
        case .appLoyaltyGradientLightBronze: return colorInfoWith(red: 0.76 * 255, green: 0.53 * 255, blue: 0.3 * 255, alpha: 0.6)
        case .appLoyaltyGradientDarkBronze: return colorInfoWith(red: 0.67 * 255, green: 0.37 * 255, blue: 0.08 * 255, alpha: 1)
            
        case .appLoyaltyGradientLightSilver: return colorInfoWith(red: 0.85 * 255, green: 0.85 * 255, blue: 0.85 * 255, alpha: 1)
        case .appLoyaltyGradientDarkSilver: return colorInfoWith(red: 0.5 * 255, green: 0.5 * 255, blue: 0.5 * 255, alpha: 1)
            
        case .appLoyaltyGradientLightGold: return colorInfoWith(red: 0.95 * 255, green: 0.85 * 255, blue: 0.52 * 255, alpha: 1)
        case .appLoyaltyGradientDarkGold: return colorInfoWith(red: 0.71 * 255, green: 0.57 * 255, blue: 0.12 * 255, alpha: 1)
            
        case .appLoyaltyGradientLightPlatinum: return colorInfoWith(red: 0.71 * 255, green: 0.71 * 255, blue: 0.71 * 255, alpha: 1)
        case .appLoyaltyGradientDarkPlatinum: return colorInfoWith(red: 0.14 * 255, green: 0.14 * 255, blue: 0.14 * 255, alpha: 1)

        case .appLoyaltyThemeBronze: return colorInfoWith(red: 0.65 * 255, green: 0.41 * 255, blue: 0.18 * 255, alpha: 0.5)
        case .appLoyaltyThemeSilver: return colorInfoWith(red: 0.65 * 255, green: 0.65 * 255, blue: 0.65 * 255, alpha: 1)
        case .appLoyaltyThemeGold: return colorInfoWith(red: 0.84 * 255, green: 0.69 * 255, blue: 0.22 * 255, alpha: 1)
        case .appLoyaltyThemePlatinum: return colorInfoWith(red: 0.29 * 255, green: 0.29 * 255, blue: 0.29 * 255, alpha: 1)
        case .appLoyaltyGradientLight: return colorInfoWith(red: 1.0 * 255, green: 0.93 * 255, blue: 0.8 * 255, alpha: 1)
        case .appLoyaltyGradientDark: return colorInfoWith(red: 0.99 * 255, green: 0.64 * 255, blue: 0.0 * 255, alpha: 1)
        case .appRedemptionRatingYellow: return colorInfoWith(red: 0.996 * 255, green: 0.835 * 255, blue: 0.004 * 255, alpha: 1)
        case .appRedemptionRatingGray: return colorInfoWith(red: 0.8 * 255, green: 0.8 * 255, blue: 0.8 * 255, alpha: 1)
        case .appNotificationGray: return colorInfoWith(red: 196, green: 196, blue: 196, alpha: 1)
        }
    }
    
    var r: CGFloat { return self.rgba[0] }
    var g: CGFloat { return self.rgba[1] }
    var b: CGFloat { return self.rgba[2] }
    var a: CGFloat { return self.rgba[3] }
    
    func colorInfoWith(red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 1.0) -> [CGFloat] {
        return [red / 255.0, green / 255.0, blue / 255.0, alpha]
    }
    
    func colorInfoRgbDividedWith(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> [CGFloat] {
        return [red, green, blue, alpha]
    }
    
}

// MARK: - UIColor extension
extension UIColor {
    
    convenience init(commonColor: CommonColor) {
        self.init(red: commonColor.r, green: commonColor.g, blue: commonColor.b, alpha: commonColor.a)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}

//
//  AppDimens.swift
//  1Link-NRLP
//
//  Created by VenD on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

public enum CommonDimens: CGFloat {
    //Should be multiple of 4

    static var screenWidth = UIScreen.main.bounds.width
    static var screenHeight = UIScreen.main.bounds.height
    case unit1x = 4
    case unit4x = 16
}

enum CommonFontSizes: CGFloat {
    case extraSmallFontSize = 10
    case smallFontSize = 12
    case mediumFontSize = 14
    case largeFontSize = 16
    case extraLargeFontSize = 18
    case ultraLargeFontSize = 20
    case extraUltraLargeFontSize = 24
}

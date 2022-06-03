//
//  FontSheet.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

public enum CommonFont {

    enum GaramondFontStyle: FontStyle {
        case bold
        case italic
        case regular

        var name: String {
            switch self {
            case .regular: return "Garamond"
            case .italic: return "Garamond-italic"
            case .bold: return "Garamond-bold"
            }
        }
        
        var nameNonTranslated: String {
            switch self {
            case .regular: return "Garamond"
            case .italic: return "Garamond-italic"
            case .bold: return "Garamond-bold"
            }
        }
    }

    enum HpSimplifiedFontStyle: FontStyle {
        case boldItalic
        case italic
        case light
        case lightItalic
        case regular
        case bold
        case regularOnlyEnglish
        case boldOnlyEnglish
        case lightOnlyEnglish
        case markaziTextRegular
        case markaziTextBold
        
        var name: String {
            switch self {
            case .boldItalic: return "HPSimplified-bold-italic"
            case .italic: return "HPSimplified-italic"
            case .lightItalic: return "HPSimplified-light-italic"
            case .regularOnlyEnglish: return "HPSimplified-regular"
            case .lightOnlyEnglish: return "HPSimplified-light"
            case .boldOnlyEnglish: return "HPSimplified-bold"
            case .markaziTextRegular: return "MarkaziText-Regular"
            case .markaziTextBold: return "MarkaziText-Bold"
            case .light: return (AppConstants.appLanguage != .urdu ? "HPSimplified-light" : HpSimplifiedFontStyle.markaziTextRegular.name)
            case .regular: return (AppConstants.appLanguage != .urdu ? "HPSimplified-regular" : HpSimplifiedFontStyle.markaziTextRegular.name)
            case .bold: return (AppConstants.appLanguage != .urdu ? "HPSimplified-bold" : HpSimplifiedFontStyle.markaziTextBold.name)
            }
        }
        
        var nameNonTranslated: String {
            switch self {
            case .boldItalic: return "HPSimplified-bold-italic"
            case .italic: return "HPSimplified-italic"
            case .lightItalic: return "HPSimplified-light-italic"
            case .regularOnlyEnglish: return "HPSimplified-regular"
            case .lightOnlyEnglish: return "HPSimplified-light"
            case .boldOnlyEnglish: return "HPSimplified-bold"
            case .markaziTextRegular: return "MarkaziText-Regular"
            case .markaziTextBold: return "MarkaziText-Bold"
            case .light: return "HPSimplified-light"
            case .regular: return "HPSimplified-regular"
            case .bold: return "HPSimplified-bold"
            }
        }
    }
}

protocol FontStyle {
    var name: String { get }
    var nameNonTranslated: String { get }
}

// MARK: - UIFont extension
extension UIFont {

    convenience init(commonFont: FontStyle, size: CGFloat, shouldTranslate: Bool = true) {
        
        let scaleSize = UIFont.getFontSizeForUrdu(commonFont: commonFont, size: size)
        self.init(name: commonFont.name, size: scaleSize * AppConstants.scaleRatio)!
    }
    
    private static func getFontSizeForUrdu(commonFont: FontStyle, size: CGFloat) -> CGFloat {
        switch commonFont {
        case CommonFont.HpSimplifiedFontStyle.markaziTextRegular, CommonFont.HpSimplifiedFontStyle.markaziTextBold :
            return size + 1
        default:
            return size
        }
    }

    convenience init(commonFont: FontStyle, size: CommonFontSizes, shouldTranslate: Bool = true) {
        
        let scaleSize = UIFont.getFontSizeForUrdu(commonFont: commonFont, size: size.rawValue)
        
        self.init(name: shouldTranslate ? commonFont.name : commonFont.nameNonTranslated, size: scaleSize * AppConstants.scaleRatio)!
    }

}

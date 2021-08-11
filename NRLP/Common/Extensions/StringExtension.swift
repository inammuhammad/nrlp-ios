//
//  StringExtension.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func isValid(for regex: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
    
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var int: Int {
        return Int(self) ?? 0
    }
    
    var double: Double {
        return self.last == "." ? 0 : Double(self) ?? 0
    }
    
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
    func getStringForHTMLContent() -> NSMutableAttributedString? {
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        
        let htmlData = self.data(using: .unicode)
        let attributedString = try? NSMutableAttributedString(data: htmlData!, options: options, documentAttributes: nil)
        attributedString?.setFontFace(font: UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.lightOnlyEnglish, size: .mediumFontSize))
        return attributedString//htmlString
    }
    
    func isHTML() -> Bool {
        return self.isValid(for: RegexConstants.htmlRegex)
    }
    
    var localized: String {
        guard let selectedLang = AppConstants.appLanguage,
            let path = Bundle.main.path(forResource: selectedLang.rawValue, ofType: "lproj"),
            let bundle = Bundle(path: path) else {
                return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
    func localized(withComment: String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
    }
    
    var containsNonEnglishNumbers: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
    
    var english: String {
        return self.applyingTransform(StringTransform.toLatin, reverse: false) ?? self
    }
    
    func base64ToImage() -> UIImage? {
        if let url = URL(string: self),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {
            return image
        }
        return nil
    }
}

//
//  UITextViewExtensions.swift
//  1Link-NRLP
//
//  Created by VenD on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            var attributes = self.attributedPlaceholder?.attributes(at: 0, effectiveRange: nil) ?? [:]
            attributes[NSAttributedString.Key.foregroundColor] = newValue!
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: attributes)
        }
    }

   var placeHolderFont: UIFont? {
        get {
            return self.placeHolderFont
        }
        set {
            var attributes = self.attributedPlaceholder?.attributes(at: 0, effectiveRange: nil) ?? [:]
            attributes[NSAttributedString.Key.font] = newValue!
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: attributes)
        }
    }
}

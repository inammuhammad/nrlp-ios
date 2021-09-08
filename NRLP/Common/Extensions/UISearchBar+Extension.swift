//
//  UISearchBar+Extension.swift
//  NRLP
//
//  Created by Bilal Iqbal on 08/09/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import UIKit
import Foundation

extension UISearchBar {
    func setTextFieldBackgroundColor(_ color: UIColor) {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                let view = subSubView as? UITextInputTraits
                if view != nil {
                    let textField = view as? UITextField
                    textField?.backgroundColor = color
                    break
                }
            }
        }
    }
    
    func setTextFieldFont(_ font: UIFont) {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                let view = subSubView as? UITextInputTraits
                if view != nil {
                    let textField = view as? UITextField
                    textField?.font = font
                    break
                }
            }
        }
    }
}

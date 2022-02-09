//
//  PaddedTextArea.swift
//  NRLP
//
//  Created by Bilal Iqbal on 27/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

import UIKit

class UITextViewPadding: UITextView {

    var padding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textContainerInset = padding
    }

    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
}

extension UITextView {
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) ||
            action == #selector(UIResponderStandardEditActions.selectAll(_:)) ||
            action == #selector(UIResponderStandardEditActions.paste(_:)) ||
            action == #selector(UIResponderStandardEditActions.cut(_:)) ||
            action == #selector(UIResponderStandardEditActions.select(_:)) ||
            action == #selector(UIResponderStandardEditActions.selectAll(_:)) {
            return false
        }
        // Default
        return super.canPerformAction(action, withSender: sender)
    }
}

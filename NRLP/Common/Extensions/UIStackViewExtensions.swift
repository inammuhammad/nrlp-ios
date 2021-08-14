//
//  UIStackViewExtensions.swift
//  1Link-NRLP
//
//  Created by VenD on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }

        for v in removedSubviews where v.superview != nil {
                NSLayoutConstraint.deactivate(v.constraints)
                v.removeFromSuperview()
        }
    }
}

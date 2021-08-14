//
//  UIView+Extensions.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

extension UIView {

    public enum ViewSide {
        case top
        case right
        case bottom
        case left
    }

    public func createBorder(side: ViewSide, thickness: CGFloat, color: UIColor,
                             leftOffset: CGFloat = 0, rightOffset: CGFloat = 0,
                             topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) -> CALayer {

        switch side {
        case .top:
            // Bottom Offset Has No Effect
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            return getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: 0 + topOffset,
                                                    width: self.frame.size.width - leftOffset - rightOffset,
                                                    height: thickness), color: color)
        case .right:
            // Left Has No Effect
            // Subtract bottomOffset from the height to get our end.
            return getOneSidedBorder(frame: CGRect(x: self.frame.size.width - thickness - rightOffset,
                                                    y: 0 + topOffset,
                                                    width: thickness,
                                                    height: self.frame.size.height - topOffset - bottomOffset), color: color)
        case .bottom:
            // Top has No Effect
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            return getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: self.frame.size.height-thickness-bottomOffset,
                                                    width: self.frame.size.width - leftOffset - rightOffset,
                                                    height: thickness), color: color)
        case .left:
            // Right Has No Effect
            return getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: 0 + topOffset,
                                                    width: thickness,
                                                    height: self.frame.size.height - topOffset - bottomOffset), color: color)
        }
    }

    //////////
    // Private: Our methods call these to add their borders.
    //////////

    fileprivate func getOneSidedBorder(frame: CGRect, color: UIColor) -> CALayer {
        let border: CALayer = CALayer()
        border.frame = frame
        border.backgroundColor = color.cgColor
        return border
    }
}

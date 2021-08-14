//
//  UIColorExtensions.swift
//  1Link-NRLP
//
//  Created by VenD on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    func image(height: Int = 1) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: height))
        if let ctx = UIGraphicsGetCurrentContext() {
            self.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 1, height: height))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return UIImage()
    }
}

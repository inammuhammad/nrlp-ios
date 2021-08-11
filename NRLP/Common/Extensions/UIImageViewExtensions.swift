//
//  UIImageViewExtensions.swift
//  1Link-NRLP
//
//  Created by VenD on 16/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func rotate(to value: Double, fromValue: Double, duration: Double = 0.5) {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: value)
        rotation.duration = duration
        rotation.fromValue = NSNumber(value: fromValue)
        rotation.fillMode = CAMediaTimingFillMode.both
        rotation.isRemovedOnCompletion = false
        rotation.repeatCount = 0
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}

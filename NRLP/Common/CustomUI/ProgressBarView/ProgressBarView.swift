//
//  ProgressBarView.swift
//  1Link-NRLP
//
//  Created by VenD on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ProgressBarView: CustomNibView {

    @IBInspectable
    var completedStateColor: UIColor? = UIColor.init(commonColor: .appYellow) {
        didSet {
            updateLayerStyle()
        }
    }

    @IBInspectable
    var remainingStateColor: UIColor? = UIColor.init(commonColor: .appLightGray) {
        didSet {
            updateLayerStyle()
        }
    }

    @IBInspectable
    var completedPercentage: Float = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }

    private var completedStateLayer: CALayer! {
        didSet {
            updateLayerStyle()
        }
    }

    private var remainingStateLayer: CALayer! {
        didSet {
            updateLayerStyle()
        }
    }

    override func setupView() {
        completedStateLayer = CALayer()
        remainingStateLayer = CALayer()

        self.layer.addSublayer(completedStateLayer)
        self.layer.addSublayer(remainingStateLayer)

        updateLayerStyle()
        updateLayerFrames()
    }

    private func updateLayerStyle() {
        completedStateLayer?.backgroundColor = completedStateColor?.cgColor
        remainingStateLayer?.backgroundColor = remainingStateColor?.cgColor
    }

    func updateLayerFrames() {
        let completedWidth = self.frame.width * CGFloat(completedPercentage)

        completedStateLayer.frame = CGRect(x: 0, y: 0, width: completedWidth, height: self.frame.height)
        remainingStateLayer.frame = CGRect(x: completedWidth, y: 0, width: self.frame.width - completedWidth, height: self.frame.height)
    }
}

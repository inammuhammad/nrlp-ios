//
//  SecondaryCTAButton.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SecondaryCTAButton: UIButton {

    var enabledStateBorderColor: UIColor? = UIColor.init(commonColor: .appGreen) {
        didSet {
            updateButtonStyleBasedOnState()
        }
    }

    var disabledStateBorderColor: UIColor? = UIColor.init(commonColor: .appLightGray) {
        didSet {
            updateButtonStyleBasedOnState()
        }
    }

    var enabledStateTitleColor: UIColor? = UIColor.init(commonColor: .appGreen) {
        didSet {
            updateButtonStyleBasedOnState()
        }
    }

    var disabledStateTitleColor: UIColor? = UIColor.init(commonColor: .appLightGray) {
        didSet {
            updateButtonStyleBasedOnState()
        }
    }

    override var isEnabled: Bool {
        didSet {
            updateButtonStyleBasedOnState()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateButtonStyleBasedOnState()
        self.cornerRadius = CommonDimens.unit1x.rawValue
    }

    private func updateButtonStyleBasedOnState() {
        if isEnabled {
            self.borderColor = enabledStateBorderColor
            self.setTitleColor(enabledStateTitleColor, for: .normal)
        } else {
            self.borderColor = disabledStateBorderColor
            self.setTitleColor(disabledStateTitleColor, for: .normal)
        }
        self.borderWidth = 1
    }
}

//
//  PrimaryCTAButton.swift
//  1Link-NRLP
//
//  Created by VenD on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

@IBDesignable
class PrimaryCTAButton: UIButton {

    var enabledStateBackgroundColor: UIColor? = UIColor.init(commonColor: .appGreen) {
        didSet {
            updateButtonStyleBasedOnState()
        }
    }

    var disabledStateBackgroundColor: UIColor? = UIColor.init(commonColor: .appLightGray) {
        didSet {
            updateButtonStyleBasedOnState()
        }
    }

    var enabledStateTitleColor: UIColor? = .white {
        didSet {
            updateButtonStyleBasedOnState()
        }
    }

    var disabledStateTitleColor: UIColor? = .white {
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
        self.titleLabel?.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
    }

    private func updateButtonStyleBasedOnState() {
        if isEnabled {
            self.backgroundColor = enabledStateBackgroundColor
            self.setTitleColor(enabledStateTitleColor, for: .normal)
        } else {
            self.backgroundColor = disabledStateBackgroundColor
            self.setTitleColor(disabledStateTitleColor, for: .normal)
        }
    }
}

//
//  SideMenuTableViewHeader.swift
//  1Link-NRLP
//
//  Created by VenD on 28/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class SideMenuTableViewHeader: CustomNibView {

    @IBOutlet private weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: CommonFontSizes.ultraLargeFontSize)
            nameLabel.languageEnforcedSemantics()
        }
    }
    @IBOutlet private weak var cnicLabel: UILabel! {
        didSet {
            cnicLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: CommonFontSizes.mediumFontSize)
            cnicLabel.languageEnforcedSemantics()
        }
    }

    func populate(with viewModel: SideMenuTableHeaderViewModel) {
        self.nameLabel.text = viewModel.name
        self.cnicLabel.text = viewModel.formattedCNIC
    }
}

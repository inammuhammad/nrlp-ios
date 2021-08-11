//
//  SideMenuTableViewCell.swift
//  1Link-NRLP
//
//  Created by VenD on 17/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet private weak var leadingImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
            titleLabel.languageEnforcedSemantics()
        }
    }

    func populate(with data: SideMenuItem) {
        titleLabel.text = data.getTitle()
        leadingImageView.image = data.getIcon()
    }
}

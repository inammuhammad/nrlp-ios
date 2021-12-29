//
//  CityListTableViewCell.swift
//  NRLP
//
//  Created by Bilal Iqbal on 28/12/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import UIKit

class CityListTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regularOnlyEnglish, size: .mediumFontSize)
            nameLabel.textColor = .black
            nameLabel.textAlignment = .left
        }
    }
    @IBOutlet private weak var seperatorView: UIView! {
        didSet {
            seperatorView.backgroundColor = UIColor.init(commonColor: .appLightGray)
        }
    }

    func populate(with city: String) {
        nameLabel.text = city
    }
}

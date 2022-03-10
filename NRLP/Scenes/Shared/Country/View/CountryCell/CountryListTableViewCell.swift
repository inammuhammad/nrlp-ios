//
//  CountryListTableViewCell.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class CountryListTableViewCell: UITableViewCell {

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

    func populate(with country: Country) {
        nameLabel.text = country.country
    }
    
    func populate(with bank: Banks) {
        nameLabel.text = bank.name
    }
}

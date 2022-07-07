//
//  BranchListTableViewCell.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 06/07/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

class BranchListTableViewCell: UITableViewCell {

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

    func populate(with branch: Branch) {
        nameLabel.text = branch.countryName
    }
    
    func populate(with banksAndExchange: BanksAndExchange) {
        nameLabel.text = banksAndExchange.name
    }
}

//
//  BenefitCategoryCell.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 14/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class BenefitCategoryCell: UITableViewCell {

    @IBOutlet weak var parentView: UIView! {
        didSet {
            parentView.cornerRadius = 5
        }
    }
    @IBOutlet weak var categroryLabel: UILabel! {
        didSet {
            categroryLabel.textColor = .black
            categroryLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
        }
    }
    
}

extension BenefitCategoryCell: BenefitCategoryCellProtocol {
    func populate(with data: NRLPBenefitCategory) {
        self.categroryLabel.text = data.name
    }
}

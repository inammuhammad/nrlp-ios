//
//  TopTabCell.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 30/04/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

class TopTabCell: UICollectionViewCell {
    
    @IBOutlet private weak var label: UILabel! {
        didSet {
            label.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.bold, size: .mediumFontSize)
            label.textColor = UIColor.init(commonColor: .appDarkGray)
        }
    }
    
    @IBOutlet private weak var selectionBar: UIView! {
        didSet {
            
        }
    }
    
    private var tabSelected: Bool = false {
        didSet {
            selectionBar.backgroundColor = tabSelected ? UIColor(commonColor: .appGreen) : UIColor(commonColor: .appLightGray)
        }
    }

    func populate(title: String, isSelected: Bool) {
        self.label.text = title
        self.tabSelected = isSelected
    }

}

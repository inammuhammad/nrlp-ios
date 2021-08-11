//
//  HomeCollectionViewHeader.swift
//  1Link-NRLP
//
//  Created by VenD on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class HomeCollectionViewHeader: UICollectionReusableView {

    @IBOutlet private weak var welcomeLabel: UILabel! {
        didSet {
            welcomeLabel.font = UIFont.init(commonFont: CommonFont.GaramondFontStyle.regular, size: .largeFontSize)
            welcomeLabel.textColor = .black
            welcomeLabel.text = "Welcome,".localized
        }
    }
    @IBOutlet private weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont.init(commonFont: CommonFont.GaramondFontStyle.bold, size: .extraUltraLargeFontSize)
            nameLabel.textColor = .black
        }
    }

    func populate(with name: String) {
        self.nameLabel.text = name
    }
}

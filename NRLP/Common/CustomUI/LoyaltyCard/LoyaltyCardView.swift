//
//  LoyaltyCardView.swift
//  1Link-NRLP
//
//  Created by VenD on 14/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class LoyaltyCardView: CustomNibView {

    private var viewModel: LoyaltyCardViewModel!
    
    @IBOutlet weak var cardImage: UIImageView! {
        didSet {
            cardImage.image = #imageLiteral(resourceName: "greenCard")
        }
    }
    @IBOutlet weak var pointsLabel: UILabel! {
        didSet {
            pointsLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.boldOnlyEnglish, size: .extraUltraLargeFontSize)
            pointsLabel.textColor = .white
        }
    }
    
    func populate(with viewModel: LoyaltyCardViewModel) {
        self.viewModel = viewModel
        setupView()
    }
    
    override func setupView() {
        pointsLabel.text = viewModel?.formattedPoints
        cardImage.image = viewModel?.imageStyle
    }
}

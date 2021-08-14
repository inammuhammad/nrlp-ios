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
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.cornerRadius = CommonDimens.unit1x.rawValue
        }
    }
    @IBOutlet weak var pointsLabel: UILabel! {
        didSet {
            pointsLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.boldOnlyEnglish, size: .extraUltraLargeFontSize)
            pointsLabel.textColor = .white
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .smallFontSize)
            descriptionLabel.textColor = .white
            descriptionLabel.text = "Current Point Balance".localized
        }
    }
    
    func populate(with viewModel: LoyaltyCardViewModel) {
        self.viewModel = viewModel
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientStyle = viewModel?.gradientStyle {
            print(containerView.frame)
            containerView.setupGradient(colors: [UIColor.init(commonColor: gradientStyle.dark).cgColor, UIColor.init(commonColor: gradientStyle.light).cgColor])
        }
    }
    
    override func setupView() {
        pointsLabel.text = viewModel?.formattedPoints
        if let gradientStyle = viewModel?.gradientStyle {
            containerView.setupGradient(colors: [UIColor.init(commonColor: gradientStyle.dark).cgColor, UIColor.init(commonColor: gradientStyle.light).cgColor])
        }
    }
}

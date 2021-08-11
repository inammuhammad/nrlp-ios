//
//  HomeCollectionViewLoyaltyCell.swift
//  1Link-NRLP
//
//  Created by VenD on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class HomeCollectionViewLoyaltyCell: UICollectionViewCell, HomeCollectionViewCellProtocol {

    @IBOutlet weak var loyaltyTypeImageIcon: UIImageView! {
        didSet {
            let icon = #imageLiteral(resourceName: "loyaltyTypeIcon")
            loyaltyTypeImageIcon.image = icon
        }
    }
    @IBOutlet weak var arrowIconForward: UIImageView! {
        didSet {
            let icon = #imageLiteral(resourceName: "arrowForwardWhite")
            arrowIconForward.image = icon
        }
    }
    @IBOutlet weak var loyaltyTypeView: UIView! {
        didSet {
            loyaltyTypeView.cornerRadius = 2
        }
    }
    @IBOutlet private weak var loyaltyPointLabel: UILabel! {
        didSet {
            loyaltyPointLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.boldOnlyEnglish, size: .extraUltraLargeFontSize)
            loyaltyPointLabel.textColor = .white
        }
    }
    @IBOutlet weak var loyaltyTypeLabel: UILabel! {
        didSet {
            loyaltyTypeLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regularOnlyEnglish, size: .smallFontSize)
            loyaltyTypeLabel.textColor = .white
        }
    }
    @IBOutlet private weak var loyaltyPointTitleLabel: UILabel! {
        didSet {
            loyaltyPointTitleLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .smallFontSize)
            loyaltyPointTitleLabel.textColor = .white
            loyaltyPointTitleLabel.text = "Current Point Balance".localized
        }
    }
    @IBOutlet private weak var redeemYourPointLabel: UILabel! {
        didSet {
            redeemYourPointLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
            redeemYourPointLabel.textColor = .white
            redeemYourPointLabel.text = "Redeem Your Points".localized
        }
    }
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.cornerRadius = CommonDimens.unit1x.rawValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if AppConstants.appLanguage == .urdu && AppConstants.systemLanguage == .urdu {
            arrowIconForward.transform.rotated(by: .pi)
        }
    }

    func populate(with data: HomeCollectionViewCellDataModelProtocol) {
        if let data = data as? HomeCollectionViewLoyaltyCellDataModel {
            loyaltyPointLabel.text = data.formattedPoints
            
            let gradientStyle = data.loyaltyCardGradientStyle
            containerView.setupGradient(colors: [UIColor.init(commonColor: gradientStyle.1).cgColor, UIColor.init(commonColor: gradientStyle.0).cgColor])
            loyaltyTypeView.backgroundColor = UIColor.init(commonColor: data.loyaltyThemeColor)
            loyaltyTypeLabel.text = data.loyaltyTitle
        }
    }
}

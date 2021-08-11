//
//  BenefitsCardCell.swift
//  1Link-NRLP
//
//  Created by VenD on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class BenefitsCardCell: UICollectionViewCell {

    @IBOutlet private weak var forwardArrow: UIImageView! {
        didSet {
            forwardArrow.tintColor = UIColor.init(commonColor: .appGreen)
        }
    }
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.cornerRadius = CommonDimens.unit1x.rawValue
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.init(commonColor: .appLightGray).cgColor
        }
    }
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var actionTitleLabel: UILabel! {
        didSet {
            actionTitleLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .smallFontSize)
            actionTitleLabel.textColor = .black
        }
    }
}

extension BenefitsCardCell: BenefitsCardCellProtocol {
    func populate(with partner: NRLPPartners) {
        actionTitleLabel.text = partner.name
        if let img = partner.imageSrc.base64ToImage() {
            imageView.image = img
        } else {
            imageView.image = UIImage(named: "partnerPlaceholder")
        }
    }
}

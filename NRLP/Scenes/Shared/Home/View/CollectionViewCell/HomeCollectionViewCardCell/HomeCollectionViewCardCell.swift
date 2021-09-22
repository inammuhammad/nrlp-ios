//
//  HomeCollectionViewCardCell.swift
//  1Link-NRLP
//
//  Created by VenD on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class HomeCollectionViewCardCell: UICollectionViewCell, HomeCollectionViewCellProtocol {

    @IBOutlet private weak var forwardArrow: UIImageView! {
        didSet {
            forwardArrow.tintColor = UIColor.init(commonColor: .appGreen)
        }
    }
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.cornerRadius = CommonDimens.unit1x.rawValue
            containerView.shadowColor = UIColor.init(commonColor: .appBottomBorderViewShadow)
            containerView.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var actionTitleLabel: UILabel! {
        didSet {
            actionTitleLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
            actionTitleLabel.textColor = .black
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadiusAndShadow()
    }

    func populate(with data: HomeCollectionViewCellDataModelProtocol, controller: BaseViewController) {
        if let data = data as? HomeCollectionViewCardCellDataModel {
            imageView.image = data.titleImage
            actionTitleLabel.text = data.actionTitle
        }
    }
}

//
//  UICollectionViewCellExtensions.swift
//  1Link-NRLP
//
//  Created by VenD on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    func setCornerRadiusAndShadow(cornerRadius: CGFloat = CommonDimens.unit1x.rawValue, shadowColor: UIColor = UIColor.init(commonColor: CommonColor.appBottomBorderViewShadow), offset: CGSize = CGSize(width: 0, height: CommonDimens.unit1x.rawValue)) {

        self.contentView.layer.cornerRadius = cornerRadius
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}

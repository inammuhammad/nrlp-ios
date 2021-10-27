//
//  RedeemServiceCell.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 24/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class RedeemServiceCell: UITableViewCell {

    @IBOutlet private weak var serviceDetail: UILabel! {
        didSet {
            serviceDetail.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regularOnlyEnglish, size: .mediumFontSize)
        }
    }
    @IBOutlet private weak var pointsView: UIView! {
        didSet {
            pointsView.cornerRadius = 5
            pointsView.backgroundColor = UIColor.init(commonColor: .appActiveBg)
        }
    }
    @IBOutlet private weak var pointsLabel: UILabel! {
        didSet {
            pointsLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .smallFontSize)
            pointsLabel.textColor = UIColor.init(commonColor: .appActiveText)
            pointsLabel.textAlignment = .center
        }
    }

    func populate(with service: Category, partner: Partner) {
        serviceDetail.text = service.categoryName
        let formattedPoints = PointsFormatter().format(string: String(service.pointsAssigned))
        if partner.partnerName.lowercased() == "SLIC".lowercased() {
            pointsLabel.isHidden = true
            pointsView.isHidden = true
        } else {
            pointsLabel.isHidden = false
            pointsView.isHidden = false
        }
        pointsLabel.text = "\(formattedPoints) " + "points".localized
        self.layoutMargins = UIEdgeInsets.zero
    }
}

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
            let icon = #imageLiteral(resourceName: "greenCard")
            loyaltyTypeImageIcon.image = icon
        }
    }

    @IBOutlet private weak var loyaltyPointLabel: UILabel! {
        didSet {
            loyaltyPointLabel.textColor = .white
        }
    }
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.textColor = .white
        }
    }
    @IBOutlet private weak var loyaltyPointTitleLabel: UILabel! {
        didSet {
            loyaltyPointTitleLabel.textColor = .white
        }
    }
    @IBOutlet weak var amountRemittanceLbl: UILabel! {
        didSet {
            amountRemittanceLbl.textColor = .white
        }
    }
    @IBOutlet weak var dateRemittanceLbl: UILabel! {
        didSet {
            dateRemittanceLbl.textColor = .white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func redeemBtnAction(_ sender: Any) {
    }
    
    func populate(with data: HomeCollectionViewCellDataModelProtocol) {
        if let data = data as? HomeCollectionViewLoyaltyCellDataModel {
            loyaltyPointLabel.text = data.formattedPoints
            nameLabel.text = data.user.fullName
            loyaltyTypeImageIcon.image = data.loyaltyCardImageStyle
            // REMITTANCE DATE AND REMITTANCE AMOUNT FIX
            amountRemittanceLbl.text = "USD 25000"
            dateRemittanceLbl.text = "11/20"
        }
    }
}

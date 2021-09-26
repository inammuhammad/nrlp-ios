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

    private var homeController: BaseViewController?
    
    
    @IBOutlet private weak var remittanceToDateView: UIView!
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
            amountRemittanceLbl.textColor = .black
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
    
    @IBAction func infoBtnAction(_ sender: Any) {
        let alert: AlertViewModel
        let okButton = AlertActionButtonModel(buttonTitle: "OK".localized, buttonAction: nil)
        alert = AlertViewModel(alertHeadingImage: .noImage, alertTitle: "The Annual Remittance to-date in USD is accumulated from 1st July of each year, and your loyalty categoryis calculated based on this. For further details please visit FAQs", alertDescription: nil, alertAttributedDescription: nil, primaryButton: okButton, secondaryButton: nil)
        if let vc = homeController as? HomeViewController {
            vc.showAlert(with: alert)
        }
    }
    
    func populate(with data: HomeCollectionViewCellDataModelProtocol, controller: BaseViewController) {
        homeController = controller
        if let data = data as? HomeCollectionViewLoyaltyCellDataModel {
            loyaltyPointLabel.text = data.formattedPoints
            nameLabel.text = data.user.fullName
            loyaltyTypeImageIcon.image = data.loyaltyCardImageStyle
            // REMITTANCE DATE AND REMITTANCE AMOUNT FIX
            amountRemittanceLbl.text = data.remittedAmount
            dateRemittanceLbl.text = data.remittedDate
            
            if data.user.accountType == .beneficiary {
                remittanceToDateView.isHidden = true
            } else {
                remittanceToDateView.isHidden = false
            }
        }
    }
}

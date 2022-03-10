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
    @IBOutlet weak var loyaltyPointTextLbl: UILabel!{
        didSet {
            loyaltyPointTextLbl.textColor = .white
        }
    }
    @IBOutlet weak var redeemYourPointsTxtLbl: UILabel! {
        didSet {
            redeemYourPointsTxtLbl.textColor = .white
            redeemYourPointsTxtLbl.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: CommonFontSizes.largeFontSize)
        }
    }
    @IBOutlet weak var memberSinceTxtLbl: UILabel! {
        didSet {
            memberSinceTxtLbl.textColor = .white
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
    @IBOutlet weak var annualRemittanceTxtLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func redeemBtnAction(_ sender: Any) {
    }
    
    @IBAction func infoBtnAction(_ sender: Any) {
        let alert: AlertViewModel
        let okButton = AlertActionButtonModel(buttonTitle: "OK".localized, buttonAction: nil)
        alert = AlertViewModel(alertHeadingImage: .noImage, alertTitle: "USDtext".localized, alertDescription: nil, alertAttributedDescription: nil, primaryButton: okButton, secondaryButton: nil)
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
            
            redeemYourPointsTxtLbl.text = "Redeem your points".localized
            memberSinceTxtLbl.text = "Member since".localized
            loyaltyPointTextLbl.text = "Your loyalty points".localized
            
            annualRemittanceTxtLbl.text = "Annual remittance to date".localized
            
            if data.user.accountType == .beneficiary {
                remittanceToDateView.isHidden = true
            } else {
                remittanceToDateView.isHidden = false
            }
        }
    }
}

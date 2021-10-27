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
            pointsLabel.textColor = .white
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.textColor = .white
        }
    }
    
    @IBOutlet weak var memberSinceLabel: UILabel! {
        didSet {
            memberSinceLabel.textColor = .white
        }
    }
    
    @IBOutlet weak var loyaltyPointTextLbl: UILabel!{
        didSet {
            loyaltyPointTextLbl.textColor = .white
        }
    }
    @IBOutlet weak var memberSinceTxtLbl: UILabel!{
        didSet {
            memberSinceTxtLbl.textColor = .white
        }
    }
    
    func populate(with viewModel: LoyaltyCardViewModel) {
        self.viewModel = viewModel
        memberSinceTxtLbl.text = "Member since".localized
        loyaltyPointTextLbl.text = "Your loyalty points".localized
        setupLoyaltyView()
    }
    
    func setupLoyaltyView() {
        nameLabel.text = viewModel.userName
        memberSinceLabel.text = viewModel.memberSince
        pointsLabel.text = viewModel?.formattedPoints
        cardImage.image = viewModel?.imageStyle
        cardImage.contentMode = .scaleToFill
    }
}

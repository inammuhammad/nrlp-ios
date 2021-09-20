//
//  HomeCollectionViewLoyaltyCellDataModel.swift
//  1Link-NRLP
//
//  Created by VenD on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

struct HomeCollectionViewLoyaltyCellDataModel: HomeCollectionViewCellDataModelProtocol {

    var cardType: HomeCellCardType = .loyalty
    var cellSize: HomeCollectionViewCellSize = .full
    var cellIdentifier: String = "HomeCollectionViewLoyaltyCell"
    var actionTitle: String = "Redeem your points"
    
    private var loyaltyPoints: String
    private var loyaltyType: LoyaltyType
    
    var formattedPoints: String {
        let formater = CurrencyFormatter()
        return formater.format(string: loyaltyPoints)
    }
    
    var loyaltyCardImageStyle: UIImage? {
        return loyaltyType.cardImage
    }
    
    var loyaltyTitle: String {
        return loyaltyType.title
    }
    
    var loyaltyThemeColor: CommonColor {
        return loyaltyType.themeColor
    }
    
    var user: UserModel
    
    var remittedAmount: String
    
    var remittedDate: String

    init(with loyaltyPoints: String, loyaltyType: LoyaltyType, user: UserModel, remittedDate: String, remittedAmount: String) {
        self.loyaltyPoints = CurrencyFormatter().format(string: loyaltyPoints)
        self.loyaltyType = loyaltyType
        self.user = user
        self.remittedDate = remittedDate
        self.remittedAmount = remittedAmount
    }
}

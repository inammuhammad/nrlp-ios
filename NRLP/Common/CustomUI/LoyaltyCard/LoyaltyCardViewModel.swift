//
//  LoyaltyCardViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 14/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

struct LoyaltyCardViewModel {
    private var loyaltyType: LoyaltyType
    private var userPoints: String
    private var user: UserModel
    
    var imageStyle: UIImage? {
        return loyaltyType.cardImage
    }
    
    var formattedPoints: String {
        let formater = CurrencyFormatter()
        return formater.format(string: userPoints)
    }
    
    var userName: String {
        return user.fullName
    }
    
    var memberSince: String? {
        return user.memberSince
    }
    
    init(with loyaltyType: LoyaltyType, userPoints: String, user: UserModel) {
        self.loyaltyType = loyaltyType
        self.userPoints = userPoints
        self.user = user
    }
}

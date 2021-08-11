//
//  LoyaltyCardViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 14/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct LoyaltyCardViewModel {
    private var loyaltyType: LoyaltyType
    private var userPoints: String
    
    var gradientStyle: (light: CommonColor, dark: CommonColor) {
        return loyaltyType.gradientColor
    }
    
    var formattedPoints: String {
        let formater = CurrencyFormatter()
        return formater.format(string: userPoints)
    }
    
    init(with loyaltyType: LoyaltyType, userPoints: String) {
        self.loyaltyType = loyaltyType
        self.userPoints = userPoints
    }
}

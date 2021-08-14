//
//  RedeemInitialRouterMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 02/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit
@testable import NRLP

class RedeemRouterMock: RedeemRouter {
    
    
    var isNavigatedToCategory = false
    var partner: Partner?
    
    init() {
        super.init(navigationController: nil)
    }
    
     override func navigateToCategory(partner: Partner, user: UserModel) {
        isNavigatedToCategory = true
        self.partner = partner
        super.navigateToCategory(partner: partner, user: user)
    }
   
}

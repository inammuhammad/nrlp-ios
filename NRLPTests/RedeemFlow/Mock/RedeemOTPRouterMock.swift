//
//  RedeemOTPRouterMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 03/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit
@testable import NRLP

class RedeemOTPRouterMock: RedeemOTPRouter {
    
    var isNavigatedToAgentScreen = false
    
    init() {
        super.init(navigationController: BaseNavigationController())
    }
    
    override func goToAgentScreen(transactionId: String, partner: Partner) {
        isNavigatedToAgentScreen = true
        super.goToAgentScreen(transactionId: transactionId, partner: partner)
    }
    
    
}

//
//  RedeemConfirmRouterMock.swift
//  NRLPTests
//
//  Created by VenD on 24/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class RedeemConfirmRouterMock: RedeemConfirmRouter {
    
    var didNavigateToFinishScreen: Bool = false
    
    override func goToFinishScreen(transactionId: String, partner: Partner) {
        didNavigateToFinishScreen = true
        super.goToFinishScreen(transactionId: transactionId, partner: partner)
    }
}

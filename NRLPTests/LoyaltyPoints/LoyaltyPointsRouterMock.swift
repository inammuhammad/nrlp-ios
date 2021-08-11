//
//  LoyaltyPointsRouterMock.swift
//  NRLPTests
//
//  Created by VenD on 25/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class LoyaltyPointsRouterMock: LoyaltyPointsRouter {
    
    var didMoveToAdvanceStatement: Bool = false
    var didNavigateToFilter: Bool = false
    
    override func moveToAdvanceStatement() {
        didMoveToAdvanceStatement = true
        super.moveToAdvanceStatement()
    }
    
    override func navigateToFilterScreen(userModel: UserModel) {
        didNavigateToFilter = true
        super.navigateToFilterScreen(userModel: userModel)
    }
}

//
//  LoyaltyStatementSuccessRouterMock.swift
//  NRLPTests
//
//  Created by VenD on 21/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class LoyaltyStatementSuccessRouterMock: LoyaltyStatementSuccessRouter {
    
    var didNavigateToRoot: Bool = false
    
    override func navigateToRoot() {
        didNavigateToRoot = true
        super.navigateToRoot()
    }
}

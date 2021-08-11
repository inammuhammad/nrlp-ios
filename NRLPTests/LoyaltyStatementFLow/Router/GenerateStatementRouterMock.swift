//
//  LoyaltyStatementRouterMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 26/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class GenerateStatementRouterMock: GenerateStatementRouter {
    
    var isNavigatedToSuccessScreen: Bool = false
    
    init() {
        super.init(navigationController: nil)
    }
    
    override func navigateToSuccessScreen() {
        isNavigatedToSuccessScreen = true
        super.navigateToSuccessScreen()
    }
}

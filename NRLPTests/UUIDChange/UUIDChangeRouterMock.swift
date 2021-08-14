//
//  UUIDChangeRouterMock.swift
//  NRLPTests
//
//  Created by VenD on 24/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class UUIDChangeRouterMock: UUIDChangeRouter {
    
    var didNavigateToLoginScreen: Bool = false
    
    override func navigateToLoginScreen() {
        didNavigateToLoginScreen = true
        super.navigateToLoginScreen()
    }
}

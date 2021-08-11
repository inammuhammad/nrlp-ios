//
//  ChangePasswordSuccessRouterMock.swift
//  NRLPTests
//
//  Created by VenD on 21/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

@testable import NRLP

class ChangePasswordSuccessRouterMock: ChangePasswordSuccessRouter {
    
    var didTapLoginScreen: Bool = false
    
    override func navigateToLoginScreen() {
        didTapLoginScreen = true
        super.navigateToLoginScreen()
    }
}

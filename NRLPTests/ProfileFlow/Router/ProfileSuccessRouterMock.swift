//
//  ProfileSuccessRouterMock.swift
//  NRLPTests
//
//  Created by VenD on 21/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class ProfileSuccessRouterMock: ProfileSuccessRouter {
    var didNavigateToHome: Bool = false
    
    override func navigateToHome() {
        didNavigateToHome = true
        super.navigateToHome()
    }
}

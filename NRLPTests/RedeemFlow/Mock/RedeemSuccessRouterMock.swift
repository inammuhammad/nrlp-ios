//
//  RedeemSuccessRouterMock.swift
//  NRLPTests
//
//  Created by VenD on 18/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit
@testable import NRLP

class RedeemSuccessRouterMock: RedeemSuccessRouter {
    
    var didNavigateToHome: Bool = false
    
    override
    init(navigationController: UINavigationController?) {
        super.init(navigationController: navigationController)
    }
    
    override
    func navigateToHome() {
        didNavigateToHome = true
        super.navigateToHome()
    }
}

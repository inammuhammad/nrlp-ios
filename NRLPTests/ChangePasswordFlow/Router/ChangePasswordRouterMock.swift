//
//  ChangePasswordRouterMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 27/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class ChangePasswordRouterMock: ChangePasswordRouter {
    
    var isNavigatedToSuccessScreen: Bool = false
    
    init() {
        super.init(navigationController: nil)
    }

    override func navigateToSuccess() {
        isNavigatedToSuccessScreen = true
        super.navigateToSuccess()
    }
}

//
//  ForgotPasswordSuccessRouterMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 03/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class ForgotPasswordSuccessRouterMock: ForgotPasswordSuccessRouter {
    
    var isNavigatedToRoot: Bool = false
    
    override
    func navigateToRoot() {
       isNavigatedToRoot = true
        super.navigateToRoot()
    }
}

//
//  ForgotPasswordRouterMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 03/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class ForgotPasswordRouterMock: ForgotPasswordRouter {
    
    var isNavigatedToOTPScreen: Bool = false
    
    init() {
        super.init(navigationController: nil)
    }
    
    override
    func navigateToOTPScreen(forgotPasswordRequestModel: ForgotPasswordSendOTPRequest) {
        isNavigatedToOTPScreen = true
        super.navigateToOTPScreen(forgotPasswordRequestModel: forgotPasswordRequestModel)
    }
    
}

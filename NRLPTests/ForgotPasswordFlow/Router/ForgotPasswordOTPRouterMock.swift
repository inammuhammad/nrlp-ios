//
//  ForgotPasswordOTPRouterMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 03/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class ForgotPasswordOTPRouterMock: ForgotPasswordOTPRouter {
    
    var isNavigatedToNewPasswordScreen: Bool = false
    
    init() {
        super.init(navigationController: nil)
    }
    
    override
    func navigateToNewPasswordScreen(forgotPasswordRequestModel: ForgotPasswordSendOTPRequest) {
        isNavigatedToNewPasswordScreen = true
        super.navigateToNewPasswordScreen(forgotPasswordRequestModel: forgotPasswordRequestModel)
    }
}

//
//  ForgotPasswordNewPassRouterMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 03/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class ForgotPasswordNewPassRouterMock: ForgotPasswordNewPassRouter {
    
    var isNavigatedToSuccess: Bool = false
    var isNavigatedToForgotPasswordScreen: Bool = false
    
    init() {
        super.init(navigationController: nil)
    }
    
    override
    func navigateToSuccess() {
        isNavigatedToSuccess = true
        super.navigateToSuccess()
    }

    override
    func navigateBackToForgotPasswordScreen() {
       isNavigatedToForgotPasswordScreen = true
        super.navigateBackToForgotPasswordScreen()
    }
}

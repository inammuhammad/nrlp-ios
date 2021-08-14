//
//  LoginRouterMock.swift
//  NRLPTests
//
//  Created by VenD on 19/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class LoginRouterMock: LoginRouter {
    
    var isNavigatedToRegisterScreen: Bool = false
    var isNavigatedToHomeScreen: Bool = false
    var isNavigatedToUUIDChangeScreen: Bool = false
    var isNavigatedToForgotPasswordScreen: Bool = false
    
    init() {
        super.init(navigationController: nil)
    }
    
    override
    func navigateToRegistrationScreen() {
        isNavigatedToRegisterScreen = true
        super.navigateToRegistrationScreen()
    }

    override
    func navigateToHomeScreen(user: UserModel) {
        isNavigatedToHomeScreen = true
//        super.navigateToHomeScreen(user: user)
    }

    override
    func navigateToUUIDChangeScreen(model: LoginRequestModel) {
        isNavigatedToUUIDChangeScreen = true
        super.navigateToUUIDChangeScreen(model: model)
    }

    override
    func navigateToForgotPassword() {
        isNavigatedToForgotPasswordScreen = true
        super.navigateToForgotPassword()
    }
}

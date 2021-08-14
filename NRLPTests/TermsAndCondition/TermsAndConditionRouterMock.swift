//
//  TermsAndConditionRouterMock.swift
//  NRLPTests
//
//  Created by VenD on 22/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class TermsAndConditionRouterMock: TermsAndConditionRouter {
    
    var didNavigateToLogin: Bool = false
    var didNavigateToRegistrationCompleted: Bool = false
    
    override func navigateToLoginScreen() {
        didNavigateToLogin = true
        super.navigateToLoginScreen()
    }
    
    override func navigateToRegistrationCompletionScreen(accountType: AccountType) {
       
       didNavigateToRegistrationCompleted = true
        super.navigateToRegistrationCompletionScreen(accountType: accountType)
    }
}

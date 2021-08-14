//
//  HomeRouterMock.swift
//  NRLPTests
//
//  Created by VenD on 22/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class HomeRouterMock: HomeRouter {
    
    var didNavigateToChangePassword: Bool = false
    var didNavigateToContactUs: Bool = false
    var didNavigateToFaqs: Bool = false
    var didNavigateToLanguageChange: Bool = false
    var didNavigateToLoginScreen: Bool = false
    var didNavigateToLoyaltyScreen: Bool = false
    var didNavigateToManageBeneficiariesScreen: Bool = false
    var didNavigateToManagePointsScreen: Bool = false
    var didNavigateToNRLPBenefits: Bool = false
    var didNavigateToProfile: Bool = false
    var didNavigateToViewStatement: Bool = false
    
    override func navigateToChangePassword() {
        didNavigateToChangePassword = true
        super.navigateToChangePassword()
    }
    
    override func navigateToContactUs() {
        didNavigateToContactUs = true
        super.navigateToContactUs()
    }
    
    override func navigateToFaqs() {
        didNavigateToFaqs = true
        super.navigateToFaqs()
    }
    
    override func navigateToLanguageChange(user: UserModel) {
        didNavigateToLanguageChange = true
        super.navigateToLanguageChange(user: user)
    }
    
    override func navigateToLoginScreen() {
        didNavigateToLoginScreen  = true
        super.navigateToLoginScreen()
    }
    
    override func navigateToLoyaltyScreen(user: UserModel) {
        didNavigateToLoyaltyScreen = true
        super.navigateToLoyaltyScreen(user: user)
    }
    
    override func navigateToManageBeneficiariesScreen(userModel: UserModel) {
        didNavigateToManageBeneficiariesScreen = true
        super.navigateToManageBeneficiariesScreen(userModel: userModel)
    }
    
    override func navigateToManagePointsScreen(userModel: UserModel) {
        didNavigateToManagePointsScreen = true
        super.navigateToManagePointsScreen(userModel: userModel)
    }
    
    override func navigateToNRLPBenefits() {
        didNavigateToNRLPBenefits = true
        super.navigateToNRLPBenefits()
    }
    
    override func navigateToProfile() {
        didNavigateToProfile = true
        super.navigateToProfile()
    }
    
    override func navigateToViewStatement(userModel: UserModel) {
        didNavigateToViewStatement = true
        super.navigateToViewStatement(userModel: userModel)
    }
}

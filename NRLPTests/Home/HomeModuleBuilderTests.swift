//
//  HomeModuleBuilderTests.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class HomeModuleBuilderTests: XCTestCase {
     
    func testBuilderNegative() {
        
        var user = getMockUser()
        user.type = ""
        
        let homeNC: UIViewController? = HomeModuleBuilder().build(for: user)
        
        XCTAssertTrue(homeNC is BaseNavigationController)
        
        let homeVC = (homeNC as! BaseNavigationController).topViewController
        
        XCTAssertTrue(homeVC is HomeViewController)
        XCTAssertNil((homeVC as! HomeViewController).viewModel)
    }
    
    func testBuilderPositiveBeneficiary() {
        var user = getMockUser()
        user.type = AccountType.beneficiary.rawValue
        
        let homeNC: UIViewController? = HomeModuleBuilder().build(for: user)
        
        XCTAssertTrue(homeNC is BaseNavigationController)
        
        let homeVC = (homeNC as! BaseNavigationController).topViewController
        
        XCTAssertTrue(homeVC is HomeViewController)
        XCTAssertTrue((homeVC as! HomeViewController).viewModel is BeneficiaryHomeViewModel)
    }
    
    func testBuilderPositiveRemitter() {
        var user = getMockUser()
        user.type = AccountType.remitter.rawValue
        
        let homeNC: UIViewController? = HomeModuleBuilder().build(for: user)
        
        XCTAssertTrue(homeNC is BaseNavigationController)
        
        let homeVC = (homeNC as! BaseNavigationController).topViewController
        
        XCTAssertTrue(homeVC is HomeViewController)
        
        XCTAssertTrue((homeVC as! HomeViewController).viewModel is RemitterHomeViewModel)
    }
}

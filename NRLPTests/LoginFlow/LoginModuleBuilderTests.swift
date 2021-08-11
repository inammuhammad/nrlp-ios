//
//  LoginModuleBuilderTests.swift
//  NRLPTests
//
//  Created by VenD on 14/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class LoginModuleBuilderTests: XCTestCase {

    func testBuilder() {
        let loginNC: UIViewController? = LoginModuleBuilder().build()
        
        XCTAssertTrue(loginNC is BaseNavigationController)
        
        let loginVC = (loginNC as! BaseNavigationController).topViewController
        
        XCTAssertTrue(loginVC is LoginViewController)
        XCTAssertTrue((loginVC as! LoginViewController).viewModel is LoginViewModel)
    }
}

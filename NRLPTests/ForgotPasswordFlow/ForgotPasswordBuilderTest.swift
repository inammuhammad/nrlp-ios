//
//  ForgotPasswordBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class ForgotPasswordBuilderTest: XCTestCase {

    func testBuilder() {
        let forgotPasswordVC: UIViewController? = ForgotPasswordBuilder().build(navigationController: BaseNavigationController())
        
        XCTAssertTrue(forgotPasswordVC is ForgotPasswordViewController)
        
        XCTAssertTrue((forgotPasswordVC as! ForgotPasswordViewController).viewModel is ForgotPasswordViewModel)
    }
}

//
//  ChangePasswordBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 14/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class ChangePasswordBuilderTest: XCTestCase {

     func testBuilder() {
        let changePasswordVC: UIViewController? = ChangePasswordBuilder().build(with: BaseNavigationController())
        
        XCTAssertTrue(changePasswordVC is ChangePasswordViewController)
        
        XCTAssertTrue((changePasswordVC as! ChangePasswordViewController).viewModel is ChangePasswordViewModel)
    }

}

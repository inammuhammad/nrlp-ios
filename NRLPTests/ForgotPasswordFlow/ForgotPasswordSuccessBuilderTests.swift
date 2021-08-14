//
//  ForgotPasswordSuccessBuilderTests.swift
//  NRLPTests
//
//  Created by VenD on 14/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class ForgotPasswordSuccessBuilderTests: XCTestCase {
    
    func testBuilder() {
        let forgotVC: UIViewController? = ForgotPasswordSuccessBuilder().build(with: BaseNavigationController())
        
        XCTAssertTrue(forgotVC is OperationCompletedViewController)
        
        XCTAssertTrue((forgotVC as! OperationCompletedViewController).viewModel is ForgotPasswordSuccessViewModel)
    }
    
}

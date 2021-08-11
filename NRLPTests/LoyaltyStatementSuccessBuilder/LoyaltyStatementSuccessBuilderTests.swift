//
//  LoyaltyStatementSuccessBuilderTests.swift
//  NRLPTests
//
//  Created by VenD on 14/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP
class LoyaltyStatementSuccessBuilderTests: XCTestCase {

    func testBuilder() {
        let operationSuccessVC: UIViewController? = LoyaltyStatementSuccessBuilder().build(with: BaseNavigationController())
        
        XCTAssertTrue(operationSuccessVC is OperationCompletedViewController)
        
        XCTAssertTrue((operationSuccessVC as! OperationCompletedViewController).viewModel is LoyaltyStatementSuccessViewModel)
    }
}

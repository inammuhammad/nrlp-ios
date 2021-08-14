//
//  RedeemSuccessBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class RedeemSuccessBuilderTest: XCTestCase {
    func testBuilder() {
        let redeemSuccessVC: UIViewController? = RedeemSuccessBuilder().build(with: BaseNavigationController(), transactionId: "abc", partner: Partner(id: 1, partnerName: "Ali", categories: []))
        
        XCTAssertTrue(redeemSuccessVC is OperationCompletedViewController)
        
        XCTAssertTrue((redeemSuccessVC as! OperationCompletedViewController).viewModel is RedeemSuccessViewModel)
    }
}

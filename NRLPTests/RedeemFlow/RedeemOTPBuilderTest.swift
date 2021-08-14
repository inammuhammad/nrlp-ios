//
//  RedeemOTPBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class RedeemOTPBuilderTest: XCTestCase {

    func testBuilder() {
        let redeemOTPVC: UIViewController? = RedeemOTPBuilder().build(with: BaseNavigationController(), transactionId: "12312312", partner: Partner(id: 1, partnerName: "Nadra", categories: []), user: getMockUser())
        
        XCTAssertTrue(redeemOTPVC is RedeemOTPViewController)
        
        XCTAssertTrue((redeemOTPVC as! RedeemOTPViewController).viewModel is RedeemOTPViewModel)
    }
}

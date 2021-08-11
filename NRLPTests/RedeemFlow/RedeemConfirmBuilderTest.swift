//
//  RedeemConfirmBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class RedeemConfirmBuilderTest: XCTestCase {

     func testBuilder() {
        let redeemConfirmVC: UIViewController? = RedeemConfirmBuilder().build(with: BaseNavigationController(), transactionId: "abc", partner: Partner(id: 1, partnerName: "Nadra", categories: []))
        
        XCTAssertTrue(redeemConfirmVC is RedeemConfirmViewController)
        
        XCTAssertTrue((redeemConfirmVC as! RedeemConfirmViewController).viewModel is RedeemConfirmViewModel)
    }

}

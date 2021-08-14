//
//  RedeemServiceBuilderTests.swift
//  NRLPTests
//
//  Created by VenD on 14/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class RedeemServiceBuilderTests: XCTestCase {

    func testBuilder() {
        let redeemVC: UIViewController? = RedeemServiceBuilder().build(with: BaseNavigationController(), partner: Partner(id: 1, partnerName: "Rahim", categories: []),user: getMockUser())
        
        XCTAssertTrue(redeemVC is RedeemServiceViewController)
        
        XCTAssertTrue((redeemVC as! RedeemServiceViewController).viewModel is RedeemServiceViewModel)
    }
}

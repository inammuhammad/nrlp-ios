//
//  RedeemModuleBuilderTests.swift
//  NRLPTests
//
//  Created by VenD on 14/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class RedeemModuleBuilderTests: XCTestCase {

    func testBuilder() {
        let redeemVC: UIViewController? = RedeemModuleBuilder().build(with: BaseNavigationController(), user: getMockUser())
        
        XCTAssertTrue(redeemVC is RedeemViewController)
        
        XCTAssertTrue((redeemVC as! RedeemViewController).viewModel is RedeemViewModel)
    }

}

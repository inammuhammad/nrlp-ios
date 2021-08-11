//
//  LoyaltyPointsBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class LoyaltyPointsBuilderTest: XCTestCase {

    func testBuilder() {
        let loyaltyPointsVC: UIViewController? = LoyaltyPointsBuilder().build(with: BaseNavigationController(), userModel: getMockUser())
        
        XCTAssertTrue(loyaltyPointsVC is LoyaltyPointsViewController)
        
        XCTAssertTrue((loyaltyPointsVC as! LoyaltyPointsViewController).viewModel is LoyaltyPointsViewModel)
    }

}

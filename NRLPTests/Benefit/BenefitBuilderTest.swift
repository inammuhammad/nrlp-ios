//
//  BenefitBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 14/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class BenefitBuilderTest: XCTestCase {

     func testBuilder() {
        let profileOTPVC: UIViewController? = BenefitsBuilder().build(with: BaseNavigationController())
        
        XCTAssertTrue(profileOTPVC is BenefitsViewController)
        
        XCTAssertTrue((profileOTPVC as! BenefitsViewController).viewModel is BenefitsViewModel)
    }

}

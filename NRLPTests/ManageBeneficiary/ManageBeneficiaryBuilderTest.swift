//
//  ManageBeneficiaryBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class ManageBeneficiaryBuilderTest: XCTestCase {

     func testBuilder() {
        let manageBeneficiaryVC: UIViewController? = ManageBeneficiaryModuleBuilder().build(with: BaseNavigationController(), user: getMockUser())
        
        XCTAssertTrue(manageBeneficiaryVC is ManageBeneficiariesViewController)
        
        XCTAssertTrue((manageBeneficiaryVC as! ManageBeneficiariesViewController).viewModel is ManageBeneficiaryViewModel)
    }
}

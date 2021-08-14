//
//  AddBeneficiaryBuilderTests.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class AddBeneficiaryBuilderTests: XCTestCase {

     func testBuilder() {
        let addBeneficiaryVC: UIViewController? = AddBeneficiaryBuilder().build(with: BaseNavigationController())
        
        XCTAssertTrue(addBeneficiaryVC is AddBeneficiaryViewController)
        
        XCTAssertTrue((addBeneficiaryVC as! AddBeneficiaryViewController).viewModel is AddBeneficiaryViewModel)
    }
}

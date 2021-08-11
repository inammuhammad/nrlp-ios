//
//  RegistrationCompletedBuilderTests.swift
//  NRLPTests
//
//  Created by VenD on 14/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class RegistrationCompletedBuilderTests: XCTestCase {

    func testBuilder() {
        let registrationCompletedVC: UIViewController? = RegistrationCompletedModuleBuilder().build(with: BaseNavigationController(), accountType: .beneficiary)
        
        XCTAssertTrue(registrationCompletedVC is OperationCompletedViewController)
        
        XCTAssertTrue((registrationCompletedVC as! OperationCompletedViewController).viewModel is RegistrationCompletedViewModel)
    }

}

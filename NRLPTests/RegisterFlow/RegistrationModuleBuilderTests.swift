//
//  RegistrationModuleBuilderTests.swift
//  NRLPTests
//
//  Created by VenD on 14/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class RegistrationModuleBuilderTests: XCTestCase {

    func testBuilder() {
        let registrationVC: UIViewController? = RegistrationModuleBuilder().build(with: BaseNavigationController())
        
        XCTAssertTrue(registrationVC is RegistrationViewController)
        
        XCTAssertTrue((registrationVC as! RegistrationViewController).viewModel is RegistrationViewModel)
    }

}

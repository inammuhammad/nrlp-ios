//
//  ProfileSuccessBuilderTests.swift
//  NRLPTests
//
//  Created by VenD on 14/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class ProfileSuccessBuilderTests: XCTestCase {

     func testBuilder() {
        let profileVC: UIViewController? = ProfileSuccessBuilder().build(with: BaseNavigationController())
        
        XCTAssertTrue(profileVC is OperationCompletedViewController)
        
        XCTAssertTrue((profileVC as! OperationCompletedViewController).viewModel is ProfileSuccessViewModel)
    }
}

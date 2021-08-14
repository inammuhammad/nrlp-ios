//
//  ProfileBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class ProfileBuilderTest: XCTestCase {

    func testBuilder() {
        let profileVC: UIViewController? = ProfileBuilder().build(with: BaseNavigationController())
        
        XCTAssertTrue(profileVC is ProfileViewController)
        
        XCTAssertTrue((profileVC as! ProfileViewController).viewModel is ProfileViewModel)
    }
}

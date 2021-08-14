//
//  SideMenuBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class SideMenuBuilderTest: XCTestCase {

     func testBuilder() {
        let sideMenuVC: UIViewController? = SideMenuModuleBuilder().build(with: getMockUser())
        
        XCTAssertTrue(sideMenuVC is SideMenuViewController)
        
        XCTAssertTrue((sideMenuVC as! SideMenuViewController).viewModel is SideMenuViewModel)
    }

}

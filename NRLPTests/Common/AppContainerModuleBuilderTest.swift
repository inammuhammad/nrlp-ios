//
//  AppContainerModuleBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class AppContainerModuleBuilderTest: XCTestCase {

     func testBuilder() {
        let appContainerVC: UIViewController? = AppContainerModuleBuilder().build(for: getMockUser())
        
        XCTAssertTrue(appContainerVC is AppContainerViewController)
        
        XCTAssertTrue((appContainerVC as! AppContainerViewController).viewModel is AppContainerViewModel)
        XCTAssertTrue((appContainerVC as! AppContainerViewController).centerViewController is HomeViewController)
        XCTAssertTrue((appContainerVC as! AppContainerViewController).centerNavigationController is BaseNavigationController)
    }


}

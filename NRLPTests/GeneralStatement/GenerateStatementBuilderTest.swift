//
//  GenerateStatementBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP
class GenerateStatementBuilderTest: XCTestCase {

    func testBuilder() {
        let generateStatementVC: UIViewController? = GenerateStatementBuilder().build(with: BaseNavigationController(), userModel: getMockUser())
        
        XCTAssertTrue(generateStatementVC is GenerateStatementViewController)
        
        XCTAssertTrue((generateStatementVC as! GenerateStatementViewController).viewModel is GenerateStatementViewModel)
    }
}

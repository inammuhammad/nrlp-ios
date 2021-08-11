//
//  TransferPointBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class TransferPointBuilderTest: XCTestCase {
    
    func testBuilder() {
        let transferPointVC: UIViewController? = TransferPointsBuilder().build(with: BaseNavigationController(), user: getMockUser())
        
        XCTAssertTrue(transferPointVC is TransferPointsViewController)
        
        XCTAssertTrue((transferPointVC as! TransferPointsViewController).viewModel is TransferPointsViewModel)
    }

}

//
//  SideMenuTableHeaderViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 23/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class SideMenuTableHeaderViewModelTests: XCTestCase {

    func testSideMenuTableHeaderViewModel() {
        let viewModel = SideMenuTableHeaderViewModel(name: getMockUser().fullName, cnic:"\( getMockUser().cnicNicop)")
        
        XCTAssertEqual(viewModel.name, "Aqib")
        XCTAssertEqual(viewModel.formattedCNIC, "12345 - 1234567 - 1")
    }
}

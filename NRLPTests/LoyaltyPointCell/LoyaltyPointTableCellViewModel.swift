//
//  LoyaltyPointTableCellViewModel.swift
//  NRLPTests
//
//  Created by VenD on 23/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class LoyaltyPointTableCellViewModel: XCTestCase {

    func testInfo() {
        var viewModel = LoyaltyPointsTableCellViewModel(with: getMockStatementWithName())
        
        XCTAssertEqual(viewModel.infoTitle, "Transfer to Rahim")
        
        XCTAssertEqual(viewModel.formattedPoints, "1,234")
        
        XCTAssertTrue(viewModel.isEarned)
        
        XCTAssertEqual(viewModel.getCreatedData(), "")
        
        viewModel = LoyaltyPointsTableCellViewModel(with: getMockStatementWithoutName())
        
        XCTAssertEqual(viewModel.infoTitle, "Paid")
        
        XCTAssertEqual(viewModel.formattedPoints, "1,234")
        
        XCTAssertTrue(viewModel.isEarned)
        
        XCTAssertEqual(viewModel.getCreatedData(), "")
        
        viewModel = LoyaltyPointsTableCellViewModel(with: getMockStatementWithNormal())
        
        XCTAssertEqual(viewModel.infoTitle, "Transfer to Rahim")
        
        XCTAssertEqual(viewModel.formattedPoints, "1,234")
        
        XCTAssertFalse(viewModel.isEarned)
        
        XCTAssertEqual(viewModel.getCreatedData(), "")
    }
}

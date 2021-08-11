//
//  LoyaltyStatementSuccessViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 21/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import XCTest
@testable import NRLP

class LoyaltyStatementSuccessViewModelTests: XCTestCase {

    var router: LoyaltyStatementSuccessRouter!
    var viewModel: LoyaltyStatementSuccessViewModel?
    
    override func setUp() {
        router = LoyaltyStatementSuccessRouterMock(navigationController: BaseNavigationController())
        
        viewModel = LoyaltyStatementSuccessViewModel(with: router)
    }

    func testDidTapCTAButton() {
        viewModel?.didTapCTAButton()
        XCTAssertTrue((router as! LoyaltyStatementSuccessRouterMock).didNavigateToRoot)
    }

}


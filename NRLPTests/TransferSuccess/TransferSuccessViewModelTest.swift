//
//  TransferSuccessViewModelTest.swift
//  NRLPTests
//
//  Created by VenD on 17/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import XCTest
@testable import NRLP

class TransferSuccessViewModelTest: XCTestCase {
   
    var router: TransferSuccessRouter?
    var viewModel: OperationCompletedViewModelProtocol?
    
    override
    func setUp() {
        super.setUp()
        router = TransferSuccessRouterMock(navigationController: BaseNavigationController())
        viewModel = TransferSuccessViewModel(with: router!, points: "1234", beneficiary: getMockBeneficiary())
    }
    
    func testDidTapCTAButton() {
        viewModel?.didTapCTAButton()
        XCTAssertTrue((router as! TransferSuccessRouterMock).didNavigateToHome)
    }
    
    func testAlertDescription() {
        let description = viewModel?.description
        XCTAssertEqual(description?.string, "You have successfully transferred 1,234 points to Test.")
    }
}

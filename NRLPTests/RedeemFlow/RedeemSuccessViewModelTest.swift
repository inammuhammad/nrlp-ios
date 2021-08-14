//
//  RedeemSuccessViewModelTest.swift
//  NRLPTests
//
//  Created by VenD on 18/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class RedeemSuccessViewModelTest: XCTestCase {

    var router: RedeemSuccessRouter?
    var viewModel: OperationCompletedViewModelProtocol?
    
    override
    func setUp() {
        super.setUp()
        router = RedeemSuccessRouterMock(navigationController: BaseNavigationController())
        viewModel = RedeemSuccessViewModel(with: router!, transactionId: "1234", partner: getMockPartner())
    }
    
    func testDidTapCTAButton() {
        viewModel?.didTapCTAButton()
        XCTAssertTrue((router as! RedeemSuccessRouterMock).didNavigateToHome)
    }
    
    func testAlertDescription() {
        let description = viewModel?.description
        XCTAssertEqual(description?.string, "Receipt Number: 1234\n\nYou have redeemed 1,234 points at Nadra on \(DateFormat().formatDateString(to: Date(), formatter: .daySuffixFullMonth) ?? "")")
    }
}

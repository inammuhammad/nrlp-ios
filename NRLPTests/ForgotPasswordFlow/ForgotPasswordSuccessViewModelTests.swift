//
//  ForgotPasswordSuccessViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 21/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class ForgotPasswordSuccessViewModelTests: XCTestCase {

    var router: ForgotPasswordSuccessRouter!
    var viewModel: ForgotPasswordSuccessViewModel?
    
    override func setUp() {
        router = ForgotPasswordSuccessRouterMock(navigationController: BaseNavigationController())
        
        viewModel = ForgotPasswordSuccessViewModel(with: router)
    }

    func testDidTapCTAButton() {
        viewModel?.didTapCTAButton()
        XCTAssertTrue((router as! ForgotPasswordSuccessRouterMock).isNavigatedToRoot)
    }

}


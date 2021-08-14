//
//  ChangePasswordSuccessViewModelTest.swift
//  NRLPTests
//
//  Created by VenD on 21/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP
class ChangePasswordSuccessViewModelTest: XCTestCase {

    var router: ChangePasswordSuccessRouter!
    var viewModel: ChangePasswordSuccessViewModel?
    
    override func setUp() {
        router = ChangePasswordSuccessRouterMock(navigationController: BaseNavigationController())
        
        viewModel = ChangePasswordSuccessViewModel(with: router)
    }

    func testDidTapCTAButton() {
        viewModel?.didTapCTAButton()
        XCTAssertTrue((router as! ChangePasswordSuccessRouterMock).didTapLoginScreen)
    }

}


//
//  RegistrationCompletedViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 21/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class RegistrationCompletedViewModelTests: XCTestCase {

    var router: RegistrationCompletedRouter!
    var viewModel: RegistrationCompletedViewModel?
    
    override func setUp() {
        router = RegistrationCompletedRouterMock(navigationController: BaseNavigationController())
        
        viewModel = RegistrationCompletedViewModel(with: router, accountType: .beneficiary)
    }

    func testDidTapCTAButton() {
        viewModel?.didTapCTAButton()
        XCTAssertTrue((router as! RegistrationCompletedRouterMock).didTapLoginScreen)
    }

}

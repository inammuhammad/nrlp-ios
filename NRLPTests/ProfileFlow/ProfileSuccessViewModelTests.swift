//
//  ProfileSuccessViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 21/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import XCTest
@testable import NRLP

class ProfileSuccessViewModelTests: XCTestCase {

    var router: ProfileSuccessRouter!
    var viewModel: ProfileSuccessViewModel?
    
    override func setUp() {
        router = ProfileSuccessRouterMock(navigationController: BaseNavigationController())
        
        viewModel = ProfileSuccessViewModel(with: router)
    }

    func testDidTapCTAButton() {
        viewModel?.didTapCTAButton()
        XCTAssertTrue((router as! ProfileSuccessRouterMock).didNavigateToHome)
    }

}


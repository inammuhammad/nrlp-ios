//
//  ForgotNewPasswordBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class ForgotNewPasswordBuilderTest: XCTestCase {
    func testBuilder() {
        let forgotPasswordNewPassVC: UIViewController? = ForgotPasswordNewPassBuilder().build(navigationController: BaseNavigationController(), forgotPasswordRequestModel: ForgotPasswordSendOTPRequest(nicNicop: "12312312312", userType: AccountType.beneficiary.rawValue))
        
        XCTAssertTrue(forgotPasswordNewPassVC is ForgotPasswordNewPassViewController)
        
        XCTAssertTrue((forgotPasswordNewPassVC as! ForgotPasswordNewPassViewController).viewModel is ForgotPasswordNewPassViewModel)
    }

}

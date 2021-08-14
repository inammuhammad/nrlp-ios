//
//  ForgotPasswordOTPBuilderTests.swift
//  NRLPTests
//
//  Created by VenD on 14/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP
class ForgotPasswordOTPBuilderTests: XCTestCase {

    func testBuilder() {
        let forgotVC: UIViewController? = ForgotPasswordOTPBuilder().build(with: BaseNavigationController(), forgotPasswordRequestModel: ForgotPasswordSendOTPRequest(nicNicop: "12312312321312", userType: AccountType.beneficiary.rawValue))
        
        XCTAssertTrue(forgotVC is ForgotPasswordOTPViewController)
        
        XCTAssertTrue((forgotVC as! ForgotPasswordOTPViewController).viewModel is ForgotPasswordOTPViewModel)
    }

}

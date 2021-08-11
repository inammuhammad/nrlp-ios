//
//  OTPModuleBuilderTests.swift
//  NRLPTests
//
//  Created by VenD on 14/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class OTPModuleBuilderTests: XCTestCase {

    func testBuilder() {
        let otpVC: UIViewController? = OTPModuleBuilder().build(with: BaseNavigationController(), model: RegisterRequestModel(accountType: "beneficiary", cnicNicop: "123456789", email: "rahim@gmail.com", fullName: "rahim", mobileNo: "03123456789", paassword: "Abc@123", registrationCode: "abcsad", transactionAmount: "1234", transactionRefNo: "abc"))
        
        XCTAssertTrue(otpVC is OTPViewController)
        
        XCTAssertTrue((otpVC as! OTPViewController).viewModel is OTPViewModel)
    }
}

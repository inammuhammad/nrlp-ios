//
//  TermsAndConditionBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class TermsAndConditionBuilderTest: XCTestCase {
    func testBuilder() {
        let termsAndConditionVC: UIViewController? = TermsAndConditionsModuleBuilder().build(with: BaseNavigationController(), model: RegisterRequestModel(accountType: "beneficiary", cnicNicop: "123456789", email: "rahim@gmail.com", fullName: "rahim", mobileNo: "03123456789", paassword: "Abc@123", registrationCode: "abcsad", transactionAmount: "1234", transactionRefNo: "abc"))
        
        XCTAssertTrue(termsAndConditionVC is TermsAndConditionsViewController)
        
        XCTAssertTrue((termsAndConditionVC as! TermsAndConditionsViewController).viewModel is TermsAndConditionViewModel)
    }
}

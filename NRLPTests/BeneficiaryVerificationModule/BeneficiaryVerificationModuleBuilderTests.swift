//
//  BeneficiaryVerificationModuleBuilderTests.swift
//  NRLPTests
//
//  Created by VenD on 14/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class BeneficiaryVerificationModuleBuilderTests: XCTestCase {

    func testBuilder() {
        let verificationVC: UIViewController? = BeneficiaryVerificationModuleBuilder().build(with: BaseNavigationController(), model: RegisterRequestModel(accountType: "beneficiary", cnicNicop: "123456789", email: "rahim@gmail.com", fullName: "rahim", mobileNo: "03123456789", paassword: "Abc@123", registrationCode: "abcsad", transactionAmount: "1234", transactionRefNo: "abc"))
        
        XCTAssertTrue(verificationVC is BeneficiaryVerificationViewController)
        
        XCTAssertTrue((verificationVC as! BeneficiaryVerificationViewController).viewModel is BeneficiaryVerificationViewModel)
    }
}

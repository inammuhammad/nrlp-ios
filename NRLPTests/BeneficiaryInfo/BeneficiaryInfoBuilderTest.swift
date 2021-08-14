//
//  BeneficiaryInfoBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class BeneficiaryInfoBuilderTest: XCTestCase {
    func testBuilder() {
        let beneficiaryInfoVC: UIViewController? = BeneficiaryInfoModuleBuilder().build(with: BaseNavigationController(), beneficiary: BeneficiaryModel(alias: "Rahim", beneficiaryId: 1, isActive: 1, mobileNo: "03428111111", nicNicop: 1, createdAt: "", updatedAt: "", isDeleted: 1), service: ManageBeneficiaryServicePositiveMock())
        
        XCTAssertTrue(beneficiaryInfoVC is BeneficiaryInfoViewController)
        
        XCTAssertTrue((beneficiaryInfoVC as! BeneficiaryInfoViewController).viewModel is BeneficiaryInfoViewModel)
    }

}

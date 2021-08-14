//
//  TransferSuccessBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class TransferSuccessBuilderTest: XCTestCase {

    func testBuilder() {
        let transferSuccessVC: UIViewController? = TransferSuccessModuleBuilder().build(with: BaseNavigationController(), points: "1234", beneficiary: BeneficiaryModel(alias: "Rahim", beneficiaryId: 1, isActive: 1, mobileNo: "03428031559", nicNicop: 1, createdAt: "", updatedAt: "", isDeleted: 1))
        
        XCTAssertTrue(transferSuccessVC is OperationCompletedViewController)
        
        XCTAssertTrue((transferSuccessVC as! OperationCompletedViewController).viewModel is TransferSuccessViewModel)
    }

}

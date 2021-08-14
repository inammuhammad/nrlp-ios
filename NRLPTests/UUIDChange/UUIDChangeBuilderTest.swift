//
//  UUIDChangeBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class UUIDChangeBuilderTest: XCTestCase {

    func testBuilder() {
        let uuidChangeVC: UIViewController? = UUIDChangeBuilder().build(with: BaseNavigationController(), model: LoginRequestModel(accountType: AccountType.beneficiary.rawValue, cnicNicop: "12312312", paassword: "Abc12345"))
        
        XCTAssertTrue(uuidChangeVC is UUIDChangeViewController)
        
        XCTAssertTrue((uuidChangeVC as! UUIDChangeViewController).viewModel is UUIDChangeViewModel)
    }

}

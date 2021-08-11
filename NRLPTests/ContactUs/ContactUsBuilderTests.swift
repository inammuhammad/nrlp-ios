//
//  ContactUsBuilderTests.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class ContactUsBuilderTests: XCTestCase {

     func testBuilder() {
        let contactUsVC: UIViewController? = ContactUsBuilder().build()
        
        XCTAssertTrue(contactUsVC is ContactUsViewController)
        
        XCTAssertTrue((contactUsVC as! ContactUsViewController).viewModel is ContactUsViewModel)
    }
}

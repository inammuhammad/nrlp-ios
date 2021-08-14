//
//  FAQModuleBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class FAQModuleBuilderTest: XCTestCase {

     func testBuilder() {
        let faqVC: UIViewController? = FAQModuleBuilder().build()
        
        XCTAssertTrue(faqVC is FAQViewController)
        
        XCTAssertTrue((faqVC as! FAQViewController).viewModel is FAQViewModel)
    }

}

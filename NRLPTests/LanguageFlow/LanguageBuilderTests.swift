//
//  LanguageBuilderTests.swift
//  NRLPTests
//
//  Created by VenD on 14/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class LanguageBuilderTests: XCTestCase {

    func testBuilder() {
        var languageVC: UIViewController? = LanguageBuilder().build(navigationController: BaseNavigationController(), user: getMockUser())
        
        XCTAssertTrue(languageVC is LanguageViewController)
        XCTAssertTrue((languageVC as! LanguageViewController).viewModel is LanguageViewModel)
        
        let languageNC = LanguageBuilder().build(navigationController: nil, user: getMockUser())
        
        languageVC = (languageNC as! BaseNavigationController).topViewController
        
        XCTAssertTrue(languageVC is LanguageViewController)
        XCTAssertTrue(languageNC is BaseNavigationController)
        XCTAssertTrue((languageVC as! LanguageViewController).viewModel is LanguageViewModel)
    }
}

//
//  AppRouterTests.swift
//  NRLPTests
//
//  Created by VenD on 14/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class AppRouterTests: XCTestCase {

    let appRouter = AppRouter()
    
    override func setUp() {
        NRLPUserDefaults.shared.removeSelectedLanguage()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAppRouter() {
        var topViewController = (appRouter.getTopViewController() as! UINavigationController).topViewController
        XCTAssertTrue(topViewController is LanguageViewController)
        
        NRLPUserDefaults.shared.set(selectedLanguage: .english)
        topViewController = (appRouter.getTopViewController() as! UINavigationController).topViewController
        XCTAssertTrue(topViewController is LoginViewController)
    }

}

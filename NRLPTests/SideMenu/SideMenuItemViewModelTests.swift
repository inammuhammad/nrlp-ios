//
//  SideMenuItemViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 23/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class SideMenuItemViewModelTests: XCTestCase {

    func testSideMenuItem() {
        var item = SideMenuItem.profile
        
        XCTAssertEqual(item.getTitle(), "Profile")
        
        item = SideMenuItem.changePassword
        
        XCTAssertEqual(item.getTitle(), "Change Password")
        
        item = SideMenuItem.faqs
        
        XCTAssertEqual(item.getTitle(), "FAQs")
        
        item = SideMenuItem.languageSelection
        
        XCTAssertEqual(item.getTitle(), "Language Selection")
        
        item = SideMenuItem.contactUs
        
        XCTAssertEqual(item.getTitle(), "Contact Us")
        
        item = SideMenuItem.logout
        
        XCTAssertEqual(item.getTitle(), "Logout")
    }

}

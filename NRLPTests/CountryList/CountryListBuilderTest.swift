//
//  CountryListBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP
class CountryListBuilderTest: XCTestCase {

     func testBuilder() {
        let countryListVC: UIViewController? = CountryListModuleBuilder().build(with: BaseNavigationController(), onCountrySelection: {list in
            print(list.code)
        })
        
        XCTAssertTrue(countryListVC is CountryListViewController)
        
        XCTAssertTrue((countryListVC as! CountryListViewController).viewModel is CountryListViewModel)
    }
}

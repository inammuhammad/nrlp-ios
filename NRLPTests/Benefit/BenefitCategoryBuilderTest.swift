//
//  BenefitCategoryBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 15/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class BenefitCategoryBuilderTest: XCTestCase {

     func testBuilder() {
        let benefitCategoriesVC: UIViewController? = BenefitsCategoriesBuilder().build(with: BaseNavigationController(), partner: NRLPPartners(name: "Nadra", imageSrc: "", id: 1))
        
        XCTAssertTrue(benefitCategoriesVC is BenefitsCategoriesViewController)
        
        XCTAssertTrue((benefitCategoriesVC as! BenefitsCategoriesViewController).viewModel is BenefitsCategoriesViewModel)
    }

}

//
//  BeneficiaryHomeViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 22/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class BeneficiaryHomeViewModelTests: XCTestCase {

    var router = HomeRouterMock(navigationController: BaseNavigationController())
    
    override func tearDown() {
        NRLPUserDefaults.shared.set(selectedLanguage: .english)
    }
    
    func testSetupCollectionViewData() {
        var viewModel = BeneficiaryHomeViewModel(with: getMockUser(), router: router, userProfileService: UserProfileServicePositiveMock(), logoutService: LogoutServicePositiveMock())
        
        NRLPUserDefaults.shared.set(selectedLanguage: .english)
        
        viewModel.setupCollectionViewData()
        
        XCTAssertEqual(viewModel.numberOfItems, 3)
        XCTAssertEqual(viewModel.collectionViewItemData[1].actionTitle, "View Statement")
        XCTAssertEqual(viewModel.collectionViewItemData[1].cardType, HomeCellCardType.viewStatement)
        XCTAssertEqual(viewModel.collectionViewItemData[1].cellIdentifier, "HomeCollectionViewCardCell")
        
        XCTAssertEqual(viewModel.collectionViewItemData[2].actionTitle, "View NRLP Benefits")
        XCTAssertEqual(viewModel.collectionViewItemData[2].cardType, HomeCellCardType.nrlpBenefits)
        XCTAssertEqual(viewModel.collectionViewItemData[2].cellIdentifier, "HomeCollectionViewCardCell")
        
        NRLPUserDefaults.shared.set(selectedLanguage: .urdu)
        
        viewModel = BeneficiaryHomeViewModel(with: getMockUser(), router: router, userProfileService: UserProfileServicePositiveMock(), logoutService: LogoutServicePositiveMock())
        
        viewModel.setupCollectionViewData()
        
        XCTAssertEqual(viewModel.numberOfItems, 3)
        XCTAssertEqual(viewModel.collectionViewItemData[1].actionTitle, "View NRLP Benefits".localized)
        XCTAssertEqual(viewModel.collectionViewItemData[1].cardType, HomeCellCardType.nrlpBenefits)
        XCTAssertEqual(viewModel.collectionViewItemData[1].cellIdentifier, "HomeCollectionViewCardCell")
        
        XCTAssertEqual(viewModel.collectionViewItemData[2].actionTitle, "View Statement".localized)
        XCTAssertEqual(viewModel.collectionViewItemData[2].cardType, HomeCellCardType.viewStatement)
        XCTAssertEqual(viewModel.collectionViewItemData[2].cellIdentifier, "HomeCollectionViewCardCell")
    }
    
    func testDidTapItem() {
        let viewModel = BeneficiaryHomeViewModel(with: getMockUser(), router: router, userProfileService: UserProfileServicePositiveMock(), logoutService: LogoutServicePositiveMock())
        
        viewModel.setupCollectionViewData()
        
        viewModel.didTapItem(at: 0)
        XCTAssertTrue(router.didNavigateToLoyaltyScreen)
        
        viewModel.didTapItem(at: 1)
        XCTAssertTrue(router.didNavigateToViewStatement)
        
        viewModel.didTapItem(at: 2)
        XCTAssertTrue(router.didNavigateToNRLPBenefits)
    }

}

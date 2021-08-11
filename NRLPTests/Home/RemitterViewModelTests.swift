//
//  RemitterViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 23/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class RemitterViewModelTests: XCTestCase {
    
    var router = HomeRouterMock(navigationController: BaseNavigationController())
    
    override func tearDown() {
        NRLPUserDefaults.shared.set(selectedLanguage: .english)
    }
    
    func testSetupCollectionViewData() {
        var viewModel = RemitterHomeViewModel(with: getMockUser(), router: router, userProfileService: UserProfileServicePositiveMock(), logoutService: LogoutServicePositiveMock())
        
        NRLPUserDefaults.shared.set(selectedLanguage: .english)
        
        viewModel.setupCollectionViewData()
        
        XCTAssertEqual(viewModel.numberOfItems, 5)
        XCTAssertEqual(viewModel.collectionViewItemData[1].actionTitle, "Manage Beneficiary")
        XCTAssertEqual(viewModel.collectionViewItemData[1].cardType, HomeCellCardType.manageBeneficiary)
        XCTAssertEqual(viewModel.collectionViewItemData[1].cellIdentifier, "HomeCollectionViewCardCell")
        
        XCTAssertEqual(viewModel.collectionViewItemData[2].actionTitle, "Transfer Points")
        XCTAssertEqual(viewModel.collectionViewItemData[2].cardType, HomeCellCardType.managePoints)
        XCTAssertEqual(viewModel.collectionViewItemData[2].cellIdentifier, "HomeCollectionViewCardCell")
        
        XCTAssertEqual(viewModel.collectionViewItemData[3].actionTitle, "View Statement")
        XCTAssertEqual(viewModel.collectionViewItemData[3].cardType, HomeCellCardType.viewStatement)
        XCTAssertEqual(viewModel.collectionViewItemData[3].cellIdentifier, "HomeCollectionViewCardCell")
        
        XCTAssertEqual(viewModel.collectionViewItemData[4].actionTitle, "View NRLP Benefits")
        XCTAssertEqual(viewModel.collectionViewItemData[4].cardType, HomeCellCardType.nrlpBenefits)
        XCTAssertEqual(viewModel.collectionViewItemData[4].cellIdentifier, "HomeCollectionViewCardCell")
        
        NRLPUserDefaults.shared.set(selectedLanguage: .urdu)
        
        viewModel = RemitterHomeViewModel(with: getMockUser(), router: router, userProfileService: UserProfileServicePositiveMock(), logoutService: LogoutServicePositiveMock())
        
        viewModel.setupCollectionViewData()
        
        XCTAssertEqual(viewModel.numberOfItems, 5)
        XCTAssertEqual(viewModel.collectionViewItemData[1].actionTitle, "Transfer Points".localized)
        XCTAssertEqual(viewModel.collectionViewItemData[1].cardType, HomeCellCardType.managePoints)
        XCTAssertEqual(viewModel.collectionViewItemData[1].cellIdentifier, "HomeCollectionViewCardCell")
        
        XCTAssertEqual(viewModel.collectionViewItemData[2].actionTitle, "Manage Beneficiary".localized)
        XCTAssertEqual(viewModel.collectionViewItemData[2].cardType, HomeCellCardType.manageBeneficiary)
        XCTAssertEqual(viewModel.collectionViewItemData[2].cellIdentifier, "HomeCollectionViewCardCell")
        
        XCTAssertEqual(viewModel.collectionViewItemData[3].actionTitle, "View NRLP Benefits".localized)
        XCTAssertEqual(viewModel.collectionViewItemData[3].cardType, HomeCellCardType.nrlpBenefits)
        XCTAssertEqual(viewModel.collectionViewItemData[3].cellIdentifier, "HomeCollectionViewCardCell")
        
        XCTAssertEqual(viewModel.collectionViewItemData[4].actionTitle, "View Statement".localized)
        XCTAssertEqual(viewModel.collectionViewItemData[4].cardType, HomeCellCardType.viewStatement)
        XCTAssertEqual(viewModel.collectionViewItemData[4].cellIdentifier, "HomeCollectionViewCardCell")
    }
    
    func testDidTapItem() {
        let viewModel = RemitterHomeViewModel(with: getMockUser(), router: router, userProfileService: UserProfileServicePositiveMock(), logoutService: LogoutServicePositiveMock())
        
        viewModel.setupCollectionViewData()
        
        viewModel.didTapItem(at: 0)
        XCTAssertTrue(router.didNavigateToLoyaltyScreen)
        
        viewModel.didTapItem(at: 1)
        XCTAssertTrue(router.didNavigateToManageBeneficiariesScreen)
        
        viewModel.didTapItem(at: 2)
        XCTAssertTrue(router.didNavigateToManagePointsScreen)
        
        viewModel.didTapItem(at: 3)
        XCTAssertTrue(router.didNavigateToViewStatement)
        
        viewModel.didTapItem(at: 4)
        XCTAssertTrue(router.didNavigateToNRLPBenefits)
    }
    
}

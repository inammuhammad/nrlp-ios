//
//  HomeViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 23/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP
class HomeViewModelTests: XCTestCase {

    var router = HomeRouterMock(navigationController: BaseNavigationController())

    func testTitleName() {
        let viewModel = HomeViewModel(with: getMockUser(), router: router, userProfileService: UserProfileServicePositiveMock(), logoutService: LogoutServicePositiveMock())
        
        let titleName = viewModel.getTitleName
        
        XCTAssertEqual(titleName, "Aqib")
    }
    
    func testViewModelDidLoad() {
        let viewModel = HomeViewModel(with: getMockUser(), router: router, userProfileService: UserProfileServicePositiveMock(), logoutService: LogoutServicePositiveMock())
        
        let outputHandler = HomeViewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.viewModelDidLoad()
        
        XCTAssertTrue(outputHandler.reloadCollectionView)
        
        XCTAssertEqual(viewModel.collectionViewItemData.count, 1)
        XCTAssertEqual(viewModel.numberOfItems, 1)
        XCTAssertTrue(viewModel.getItem(at: 0) is HomeCollectionViewLoyaltyCellDataModel)
        XCTAssertEqual(viewModel.getItem(at: 0).actionTitle, "Redeem your points")
        XCTAssertEqual(viewModel.getItem(at: 0).cardType, HomeCellCardType.loyalty)
        XCTAssertEqual(viewModel.getItem(at: 0).cellIdentifier, "HomeCollectionViewLoyaltyCell")
    }
    
    func testViewModelWillAppearPositive() {
        let viewModel = HomeViewModel(with: getMockUser(), router: router, userProfileService: UserProfileServicePositiveMock(), logoutService: LogoutServicePositiveMock())
        
        let outputHandler = HomeViewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.viewModelWillAppear()
        
        XCTAssertTrue(outputHandler.reloadCollectionView)
        XCTAssertEqual(viewModel.collectionViewItemData.count, 1)
        XCTAssertEqual(viewModel.numberOfItems, 1)
        XCTAssertTrue(viewModel.getItem(at: 0) is HomeCollectionViewLoyaltyCellDataModel)
        XCTAssertEqual(viewModel.getItem(at: 0).actionTitle, "Redeem your points")
        XCTAssertEqual(viewModel.getItem(at: 0).cardType, HomeCellCardType.loyalty)
        XCTAssertEqual(viewModel.getItem(at: 0).cellIdentifier, "HomeCollectionViewLoyaltyCell")
        
        let titleName = viewModel.getTitleName
        
        XCTAssertEqual(titleName, "Aqib")
    }
    
    func testViewModelWillAppearNegative() {
        let viewModel = HomeViewModel(with: getMockUser(), router: router, userProfileService: UserProfileServiceNegativeMock(), logoutService: LogoutServicePositiveMock())
                
        viewModel.viewModelWillAppear()
        
        XCTAssertEqual(viewModel.collectionViewItemData.count, 0)
        XCTAssertEqual(viewModel.numberOfItems, 0)
    }
    
    func testComingSoonAlert() {
        let viewModel = HomeViewModel(with: getMockUser(), router: router, userProfileService: UserProfileServicePositiveMock(), logoutService: LogoutServicePositiveMock())
        
        let outputHandler = HomeViewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.showComingSoonAlert()
        
        XCTAssertTrue(outputHandler.didShowAlert)
        XCTAssertNotNil(outputHandler.alert)
        XCTAssertEqual(outputHandler.alert?.alertDescription, "This feature is coming very soon")
        XCTAssertEqual(outputHandler.alert?.alertTitle, "Coming Soon")
    }
    
    func testDidTapSideMenu() {
        let viewModel = HomeViewModel(with: getMockUser(), router: router, userProfileService: UserProfileServicePositiveMock(), logoutService: LogoutServicePositiveMock())
        
        viewModel.didTapSideMenu(item: .changePassword)
        
        XCTAssertTrue(router.didNavigateToChangePassword)
        
        viewModel.didTapSideMenu(item: .contactUs)
        
        XCTAssertTrue(router.didNavigateToContactUs)
        
        viewModel.didTapSideMenu(item: .faqs)
        
        XCTAssertTrue(router.didNavigateToFaqs)
        
        viewModel.didTapSideMenu(item: .languageSelection)
        
        XCTAssertTrue(router.didNavigateToLanguageChange)
        
        viewModel.didTapSideMenu(item: .profile)
        
        XCTAssertTrue(router.didNavigateToProfile)
    }
    
    func testLogoutFlow() {
        let viewModel = HomeViewModel(with: getMockUser(), router: router, userProfileService: UserProfileServicePositiveMock(), logoutService: LogoutServicePositiveMock())
        
        let outputHandler = HomeViewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.didTapSideMenu(item: .logout)
        
        XCTAssertTrue(outputHandler.didShowLogoutAlert)
        XCTAssertNotNil(outputHandler.alert)
        XCTAssertEqual(outputHandler.alert?.alertDescription, "Are you sure you want to Logout?")
        XCTAssertEqual(outputHandler.alert?.alertTitle, "Logout")
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertTrue(router.didNavigateToLoginScreen)
    }
}

class HomeViewModelTestOutputHandler {
    
    var viewModel: HomeViewModel
    
    var didShowAlert: Bool = false
    var didCallShowActivityIndicator: Bool = false
    var didCallHideActivityIndicator: Bool = false
    var didShowError: APIResponseError? = nil
    var reloadCollectionView: Bool = false
    var didShowLogoutAlert: Bool = false
    var alert: AlertViewModel?
    
    func reset() {
        didShowAlert = false
        didCallShowActivityIndicator = false
        didCallHideActivityIndicator = false
        didShowError = nil
        reloadCollectionView = false
        didShowLogoutAlert = false
        alert = nil
    }
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        setupObeserver()
    }
    
    func setupObeserver() {
        viewModel.output = { output in
            
            switch output {
            case .showActivityIndicator(let show):
                if show {
                    self.didCallShowActivityIndicator = show
                } else {
                    self.didCallHideActivityIndicator = true
                }
            case .showError(let error):
                self.didShowError = error
            case .showAlert(let alert):
                self.didShowAlert = true
                self.alert = alert
            case .reloadCollectionView:
                self.reloadCollectionView = true
            case .showLogoutAlert(let alertModel):
                self.didShowLogoutAlert = true
                alertModel.primaryButton.buttonAction?()
                self.alert = alertModel
            }
        }
    }
    
}

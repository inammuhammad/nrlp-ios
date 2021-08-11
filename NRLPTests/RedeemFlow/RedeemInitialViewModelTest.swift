//
//  RedeemInitialViewModelTest.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 02/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class RedeemInitialViewModelTest: XCTestCase {

    private var router = RedeemRouterMock()
    private var service: RedeemServiceProtocol!
    
    private var partner: Partner!
    private var user: UserModel!
    
    private var commonUserModel: UserModel!
    
    override func setUp() {
        
        commonUserModel = getMockUser()
    }
    
    func testViewModelDidLoadPositive() {
        let viewModel = RedeemViewModel(router: router, user: commonUserModel, service: RedeemServicePositiveMock())
        let output = RedeemInitialViewModelOutputHandler(viewModel: viewModel)
        viewModel.viewDidLoad()
        XCTAssertTrue(output.didCallShowActivityIndicator)
        XCTAssertTrue(output.didCallHideActivityIndicator)
        XCTAssertTrue(output.didReloadData)
    }
    
    func testViewModelDidLoadNegative() {
        let viewModel = RedeemViewModel(router: router, user: commonUserModel, service: RedeemServiceNegativeMock())
        let output = RedeemInitialViewModelOutputHandler(viewModel: viewModel)
        viewModel.viewDidLoad()
        XCTAssertTrue(output.didCallShowActivityIndicator)
        XCTAssertTrue(output.didCallHideActivityIndicator)
        XCTAssertTrue(output.didShowAlert)
        XCTAssertNotNil(output.didShowError)
        XCTAssertEqual(output.didShowError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(output.didShowError?.errorCode, 401)
    }

    func testGetPartner() {
        
        let viewModel = RedeemViewModel(router: router, user: commonUserModel, service: RedeemServicePositiveMock())
        
        viewModel.viewDidLoad()
        let partner = viewModel.getPartner(index: 0)
        
        XCTAssertEqual(partner.categories.count, 1)
        XCTAssertEqual(partner.categoryCount, 1)
        XCTAssertEqual(partner.id, 1)
        XCTAssertEqual(partner.partnerName, "Nadra")
    }
    
    func testPartnerCount() {
        let viewModel = RedeemViewModel(router: router, user: commonUserModel, service: RedeemServicePositiveMock())
        
        XCTAssertEqual(viewModel.numberOfRows, 0)
    }
    
    func testDidSelectOption() {
        let viewModel = RedeemViewModel(router: router, user: commonUserModel, service: RedeemServicePositiveMock())
        viewModel.viewDidLoad()
        
        viewModel.didSelectOption(index: 0)
        
        XCTAssertTrue(router.isNavigatedToCategory)
        XCTAssertNotNil(router.partner)
        
        let partner = viewModel.getPartner(index: 0)
        
        XCTAssertEqual(router.partner!.categories.count, partner.categories.count)
        XCTAssertEqual(router.partner!.categoryCount, partner.categoryCount)
        XCTAssertEqual(router.partner!.id, partner.id)
        XCTAssertEqual(router.partner!.partnerName, partner.partnerName)
    }
}

class RedeemInitialViewModelOutputHandler {
    var viewModel: RedeemViewModel
    
    var didSetNextButtonStateEnabled: Bool = false
    var didSetNextButtonStateDisabled: Bool = false
    var didShowAlert: Bool = false
    var didCallShowActivityIndicator: Bool = false
    var didCallHideActivityIndicator: Bool = false
    var didShowError: APIResponseError? = nil
    var didReloadData: Bool = false
    var didUpdateLoyaltyCard: Bool = false
    
    init(viewModel: RedeemViewModel) {
        self.viewModel = viewModel
        setupObserver()
    }
    
    func reset() {
        didSetNextButtonStateEnabled = false
        didSetNextButtonStateDisabled = false
        didShowAlert = false
        didCallShowActivityIndicator = false
        didCallHideActivityIndicator = false
        didShowError = nil
        didReloadData = false
        didUpdateLoyaltyCard = false
    }
    
    func setupObserver() {
        viewModel.output = { output in
            switch output {
            case .showActivityIndicator(let show):
                if show {
                    self.didCallShowActivityIndicator = true
                } else  {
                    self.didCallHideActivityIndicator = true
                }
            case .showError(let error):
                self.didShowError = error
                self.didShowAlert = true
            case .dataReload:
                self.didReloadData = true
            }
        }
    }
}

//
//  RedeemServiceViewModelTest.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 02/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class RedeemServiceViewModelTest: XCTestCase {
    
    private var viewModel: RedeemServiceViewModelProtocol!
    var output: RedeemServiceViewModelOutput?
    private var router = RedeemServiceRouterMock()
    private var service: RedeemServiceProtocol!
    
    private var partner: Partner!
    
    var commonPartner = Partner(id: 1, partnerName: "TEST PARTNER", categories: [Category(id: 1, categoryName: "New Ticket", pointsAssigned: 8000), Category(id: 2, categoryName: "Renew Ticket", pointsAssigned: 200)])
    
    private var commonUserModel: UserModel!
    
    override func setUp() {
        
        commonUserModel = getMockUser()
        viewModel = RedeemServiceViewModel(router: router, partner: commonPartner, user: commonUserModel, service: RedeemServicePositiveMock())
    }
    
    func testRedeemServicePositive() {
        let outputHandler = RedeemServicesViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.cellDidTap(index: 1)
        XCTAssertTrue(outputHandler.didShowAlert)
        viewModel.itemSelected(index: 1)
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        viewModel.itemSelected(index: 1)
        XCTAssertTrue(router.inNavigatedToOTPScreen)
    }
    
    func testRedeemServiceNegative() {
        let outputHandler = RedeemServicesViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.cellDidTap(index: 0)
        XCTAssertTrue(outputHandler.didShowAlert)
        XCTAssertFalse(outputHandler.didCallShowActivityIndicator)
        XCTAssertFalse(router.inNavigatedToOTPScreen)
    }
    
    func testCategoryCount() {
        XCTAssertEqual(viewModel?.categoryCount, 2)
    }
    
    func testPoints() {
        
        let outputHandler = RedeemServicesViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.points = "1234"
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
        XCTAssertFalse(outputHandler.didSetNextButtonStateDisabled)
        
        outputHandler.reset()
        viewModel.points = ""
        XCTAssertFalse(outputHandler.didSetNextButtonStateEnabled)
        XCTAssertTrue(outputHandler.didSetNextButtonStateDisabled)
    }
    
    func testGetCategory() {
        let category = viewModel.getCategory(index: 0)
        XCTAssertNotNil(category)
    }
    
    func testViewDidLoad() {
        let outputHandler = RedeemServicesViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.viewDidLoad()
        
        XCTAssertTrue(outputHandler.didReloadData)
        XCTAssertNotNil(outputHandler.partnerName)
        XCTAssertEqual(outputHandler.partnerName, "TEST PARTNER")
        
        let loyaltyViewModel = outputHandler.loyaltyPointsViewModel
        XCTAssertTrue(outputHandler.didUpdateLoyaltyCard)
        XCTAssertNotNil(loyaltyViewModel)
        XCTAssertEqual(loyaltyViewModel?.formattedPoints, "1,234")
        XCTAssertEqual(loyaltyViewModel?.gradientStyle.dark, CommonColor.appLoyaltyGradientDarkBronze)
        
        XCTAssertEqual(loyaltyViewModel?.gradientStyle.light, CommonColor.appLoyaltyGradientLightBronze)
    }
    
    func testDidSelectItemNegative() {
        let vm = RedeemServiceViewModel(router: router, partner: commonPartner, user: commonUserModel, service: RedeemServiceNegativeMock())
        
        let outputHandler = RedeemServicesViewModelOutputHandler(viewModel: vm)
        
        vm.itemSelected(index: 1)
        XCTAssertNotNil(outputHandler.didShowError)
        XCTAssertEqual(outputHandler.didShowError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.didShowError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.didShowError?.errorCode, 401)
    }
}

class RedeemServicesViewModelOutputHandler {
    var viewModel: RedeemServiceViewModelProtocol
    
    var didSetNextButtonStateEnabled: Bool = false
    var didSetNextButtonStateDisabled: Bool = false
    var didShowAlert: Bool = false
    var didCallShowActivityIndicator: Bool = false
    var didCallHideActivityIndicator: Bool = false
    var didShowError: APIResponseError? = nil
    var didReloadData: Bool = false
    var partnerName: String?
    var didUpdateLoyaltyCard: Bool = false
    var loyaltyPointsViewModel: LoyaltyCardViewModel?
    
    init(viewModel: RedeemServiceViewModelProtocol) {
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
        partnerName = nil
        loyaltyPointsViewModel = nil
    }
    
    func setupObserver() {
        viewModel.output = { output in
            switch output {
            
            case .showActivityIndicator(let show):
                if show {
                    self.didCallShowActivityIndicator = true
                } else {
                    self.didCallHideActivityIndicator = true
                }
            case .showError(let error):
                self.didShowError = error
            case .nextButtonState(let enableState):
                if enableState {
                    self.didSetNextButtonStateEnabled = true
                } else {
                    self.didSetNextButtonStateDisabled = true
                }
            case .showAlert(let alert):
                self.didShowAlert = true
                alert.primaryButton.buttonAction?()
            case .reloadViewData(let partnerName):
                self.partnerName = partnerName
                self.didReloadData = true
            case .updateLoyaltyCard(let viewModel):
                self.didUpdateLoyaltyCard = true
                self.loyaltyPointsViewModel = viewModel
            }
        }
    }
}

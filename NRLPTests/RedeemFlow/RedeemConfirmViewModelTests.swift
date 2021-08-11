//
//  RedeemConfirmViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 24/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class RedeemConfirmViewModelTests: XCTestCase {

    var router = RedeemConfirmRouterMock(navigationController: BaseNavigationController())
    
    override func setUp() {
        let viewModel = RedeemConfirmViewModel(with: router, transactionId: "abc1234", partner: getMockPartner(), service: RedeemServicePositiveMock())
        
        viewModel.viewDidLoad()
    }
    
    override func tearDown() {
        let viewModel = RedeemConfirmViewModel(with: router, transactionId: "abc1234", partner: getMockPartner(), service: RedeemServicePositiveMock())
        
        viewModel.viewModelWillDisappear()
    }
    
    func testValidateCode() {
        var viewModel = RedeemConfirmViewModel(with: router, transactionId: "abc1234", partner: getMockPartner(), service: RedeemServicePositiveMock())
        
        var outputHandler = RedeemConfirmViewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.validateCode()
        
        XCTAssertFalse(outputHandler.didCallShowActivityIndicator)
        XCTAssertFalse(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertFalse(router.didNavigateToFinishScreen)
        
        XCTAssertNotNil(outputHandler.agentTextFieldError)
        
        XCTAssertEqual(outputHandler.agentTextFieldError, "Please enter a correct code.")
        
        viewModel = RedeemConfirmViewModel(with: router, transactionId: "abc1234", partner: getMockPartner(), service: RedeemServicePositiveMock())
        
        outputHandler = RedeemConfirmViewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.agentCode = "abc123;_"
        
        viewModel.validateCode()
        
        XCTAssertFalse(outputHandler.didCallShowActivityIndicator)
        XCTAssertFalse(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertFalse(router.didNavigateToFinishScreen)
        
        XCTAssertNotNil(outputHandler.agentTextFieldError)
        XCTAssertEqual(outputHandler.agentTextFieldError, "Please enter a correct code.")
        
        
        viewModel = RedeemConfirmViewModel(with: router, transactionId: "abc1234", partner: getMockPartner(), service: RedeemServicePositiveMock())
        
        outputHandler = RedeemConfirmViewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.agentCode = "abc123"
        
        viewModel.validateCode()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertTrue(router.didNavigateToFinishScreen)
        XCTAssertNil(outputHandler.agentTextFieldError)
        
        
        viewModel = RedeemConfirmViewModel(with: router, transactionId: "abc1234", partner: getMockPartner(), service: RedeemServiceNegativeMock())
        
        outputHandler = RedeemConfirmViewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.agentCode = "abc123"
        
        viewModel.validateCode()
        
        XCTAssertNotNil(outputHandler.didShowError)
        XCTAssertEqual(outputHandler.didShowError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.didShowError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.didShowError?.errorCode, 401)
    }
}

class RedeemConfirmViewModelTestOutputHandler {
    
    var viewModel: RedeemConfirmViewModel
    
    var didSetNextButtonStateEnabled: Bool = false
    var didSetNextButtonStateDisabled: Bool = false
    var didCallShowActivityIndicator: Bool = false
    var didCallHideActivityIndicator: Bool = false
    var didShowError: APIResponseError? = nil
    
    var updateCodeExpireTimer: Bool = false
    var timerEnded: Bool = false
    var agentTextFieldError: String? = nil
    
    func reset() {
        didSetNextButtonStateEnabled = false
        didSetNextButtonStateDisabled = false
        didCallShowActivityIndicator = false
        didCallHideActivityIndicator = false
        didShowError = nil
        
        updateCodeExpireTimer = false
        timerEnded = false
        
        agentTextFieldError = nil
    }
    
    init(viewModel: RedeemConfirmViewModel) {
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
            case .nextButtonState(let state):
                self.didSetNextButtonStateEnabled = state
                self.didSetNextButtonStateDisabled = !self.didSetNextButtonStateEnabled
            case .updateCodeExpireTimer(let timerString):
                self.updateCodeExpireTimer = true
            case .timerEnded:
                self.timerEnded = true
            case .agentTextField(let errorState, let error):
                self.agentTextFieldError = error
            }
        }
    }
    
}

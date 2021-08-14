//
//  ForgotPAsswordNewPassViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 25/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class ForgotPasswordNewPassViewModelTests: XCTestCase {
    
    var router = ForgotPasswordNewPassRouterMock()
    
    func testNavigateToFinishScreenNegative() {
        let viewModel = ForgotPasswordNewPassViewModel(router: router, forgotPasswordRequestModel: ForgotPasswordSendOTPRequest(nicNicop: "4220133573111", userType: "remitter"), service: ForgotPasswordServiceNegativeMock())
        
        let outputHandler = ForgotPasswordNewPassViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.navigateToFinishScreen()
        
        XCTAssertNotNil(outputHandler.newPasswordError)
        XCTAssertEqual(outputHandler.newPasswordError, "Please enter a valid password")
        
        XCTAssertNotNil(outputHandler.retypeNewPasswordError)
        XCTAssertEqual(outputHandler.retypeNewPasswordError, "Both passwords do not match")
        
        viewModel.newPassword = "abc"
        viewModel.navigateToFinishScreen()
        
        XCTAssertNotNil(outputHandler.newPasswordError)
        XCTAssertEqual(outputHandler.newPasswordError, "Please enter a valid password")
        
        XCTAssertNotNil(outputHandler.retypeNewPasswordError)
        XCTAssertEqual(outputHandler.retypeNewPasswordError, "Both passwords do not match")
        
        outputHandler.reset()
        
        viewModel.newPassword = "Abc@12345"
        
        viewModel.navigateToFinishScreen()
        
        XCTAssertNil(outputHandler.newPasswordError)
        
        XCTAssertNotNil(outputHandler.retypeNewPasswordError)
        XCTAssertEqual(outputHandler.retypeNewPasswordError, "Both passwords do not match")
        
        outputHandler.reset()
        
        viewModel.newPassword = "Abc@12345"
        viewModel.redoNewPassword = "Abc@12345"
        
        viewModel.navigateToFinishScreen()
        
        XCTAssertNil(outputHandler.retypeNewPasswordError)
        XCTAssertNil(outputHandler.newPasswordError)
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertNotNil(outputHandler.didShowError)
        XCTAssertEqual(outputHandler.didShowError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.didShowError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.didShowError?.errorCode, 401)
    }
    
    func testNavigateToFinishScreenPositive() {
        let viewModel = ForgotPasswordNewPassViewModel(router: router, forgotPasswordRequestModel: ForgotPasswordSendOTPRequest(nicNicop: "4220133573111", userType: "remitter"), service: ForgotPasswordServicePositiveMock())
        
        let outputHandler = ForgotPasswordNewPassViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.newPassword = "Abc@12345"
        viewModel.redoNewPassword = "Abc@12345"
        
        viewModel.navigateToFinishScreen()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertTrue(router.isNavigatedToSuccess)
    }
    
    func testValidateRequiredFields() {
        let viewModel = ForgotPasswordNewPassViewModel(router: router, forgotPasswordRequestModel: ForgotPasswordSendOTPRequest(nicNicop: "4220133573111", userType: "remitter"), service: ForgotPasswordServicePositiveMock())
        
        let outputHandler = ForgotPasswordNewPassViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.newPassword = ""
        viewModel.redoNewPassword = ""
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateDisabled)
        
        outputHandler.reset()
        
        viewModel.newPassword = "a"
        viewModel.redoNewPassword = ""
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateDisabled)
        
        outputHandler.reset()
        
        viewModel.newPassword = "a"
        viewModel.redoNewPassword = "a"
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
    }
    
    func testDidTapBackButton() {
        let viewModel = ForgotPasswordNewPassViewModel(router: router, forgotPasswordRequestModel: ForgotPasswordSendOTPRequest(nicNicop: "4220133573111", userType: "remitter"), service: ForgotPasswordServicePositiveMock())
        
        viewModel.didTapBackButton()
        
        XCTAssertTrue(router.isNavigatedToForgotPasswordScreen)
    }
    
    func testValidateConfirmPassword() {
        let viewModel = ForgotPasswordNewPassViewModel(router: router, forgotPasswordRequestModel: ForgotPasswordSendOTPRequest(nicNicop: "4220133573111", userType: "remitter"), service: ForgotPasswordServicePositiveMock())
        
        let outputHandler = ForgotPasswordNewPassViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.validateConfirmPassword()
        
        XCTAssertNil(outputHandler.retypeNewPasswordError)
        
        
        viewModel.newPassword = "abc"
        
        viewModel.validateConfirmPassword()
        
        XCTAssertNotNil(outputHandler.retypeNewPasswordError)
        XCTAssertEqual(outputHandler.retypeNewPasswordError, "Both passwords do not match")
        
        outputHandler.reset()
        
        viewModel.newPassword = "Abc@12345"
        
        viewModel.validateConfirmPassword()
        
        XCTAssertNotNil(outputHandler.retypeNewPasswordError)
        XCTAssertEqual(outputHandler.retypeNewPasswordError, "Both passwords do not match")
        
        outputHandler.reset()
        
        viewModel.newPassword = "Abc@12345"
        viewModel.redoNewPassword = "Abc@12345"
        
        viewModel.validateConfirmPassword()
        
        XCTAssertNil(outputHandler.retypeNewPasswordError)
    }
}

class ForgotPasswordNewPassViewModelOutputHandler {
    
    var viewModel: ForgotPasswordNewPassViewModel
    
    var didSetNextButtonStateEnabled: Bool = false
    var didSetNextButtonStateDisabled: Bool = false
    var didCallShowActivityIndicator: Bool = false
    var didCallHideActivityIndicator: Bool = false
    var didShowError: APIResponseError? = nil
    
    var newPasswordError: String?
    var retypeNewPasswordError: String?
    
    func reset() {
        didSetNextButtonStateEnabled = false
        didSetNextButtonStateDisabled = false
        didCallShowActivityIndicator = false
        didCallHideActivityIndicator = false
        didShowError = nil
        
        newPasswordError = nil
        retypeNewPasswordError = nil
    }
    
    init(viewModel: ForgotPasswordNewPassViewModel) {
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
            case .newPasswordTextField(_, let error):
                self.newPasswordError = error
            case .retypeNewPasswordTypeTextField(_, let error):
                self.retypeNewPasswordError = error
            }
        }
    }
    
}

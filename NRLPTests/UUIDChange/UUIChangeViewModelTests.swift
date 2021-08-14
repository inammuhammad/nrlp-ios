//
//  UUIChangeViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 24/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class UUIChangeViewModelTests: XCTestCase {

    var router = UUIDChangeRouterMock(navigationController: BaseNavigationController())
    
    func testGetVerificationCode() {
        let viewModel = UUIDChangeViewModel(with: router, model: LoginRequestModel(accountType: "remitter", cnicNicop: "1231312312", paassword: "Abc12345"), service: LoginServicePositiveMock())
        
        XCTAssertEqual(viewModel.getVerificationCode(), "")
        
        viewModel.otpCode = [1, nil, nil, nil]
        
        XCTAssertEqual(viewModel.getVerificationCode(), "1000")
        
        viewModel.otpCode = [1, nil]
        
        XCTAssertEqual(viewModel.getVerificationCode(), "10")
    }
    
    func testNavigateToLoginScreen() {
        let viewModel = UUIDChangeViewModel(with: router, model: LoginRequestModel(accountType: "remitter", cnicNicop: "1231312312", paassword: "Abc12345"), service: LoginServicePositiveMock())
        
        viewModel.navigateToLoginScreen()
        
        XCTAssertTrue(router.didNavigateToLoginScreen)
    }
    
    func testDidTapVerifyButtonPositive() {
        let viewModel = UUIDChangeViewModel(with: router, model: LoginRequestModel(accountType: "remitter", cnicNicop: "1231312312", paassword: "Abc12345"), service: LoginServicePositiveMock())
        
        let outputHandler = UUIDChangeViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.didTapVerifyButton()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertNotNil(outputHandler.alert)
        XCTAssertTrue(outputHandler.didShowAlert)
        
        XCTAssertEqual(outputHandler.alert?.alertDescription, "Device verified successfully. You will be redirected to Login screen. Please login again.")
        XCTAssertEqual(outputHandler.alert?.alertTitle, "Device Verified")
        
        XCTAssertTrue(router.didNavigateToLoginScreen)
    }
    
    func testDidTapVerifyButtonNegative() {
        let viewModel = UUIDChangeViewModel(with: router, model: LoginRequestModel(accountType: "remitter", cnicNicop: "1231312312", paassword: "Abc12345"), service: LoginServiceNegativeMock())
        
        let outputHandler = UUIDChangeViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.didTapVerifyButton()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertNotNil(outputHandler.didShowError)
        XCTAssertEqual(outputHandler.didShowError?.message, "Something unexpected happened. Please try again")
        XCTAssertEqual(outputHandler.didShowError?.title, "Oh Snap!")
        XCTAssertEqual(outputHandler.didShowError?.errorCode, 500)
    }
    
    func testDidTapResendButtonPositive() {
        let viewModel = UUIDChangeViewModel(with: router, model: LoginRequestModel(accountType: "remitter", cnicNicop: "1231312312", paassword: "Abc12345"), service: LoginServicePositiveMock())
        
        let outputHandler = UUIDChangeViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.resendOtpRequest()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertTrue(outputHandler.didShowResendOTPDialog)
    }
    
    func testDidTapResendButtonNegative() {
        let viewModel = UUIDChangeViewModel(with: router, model: LoginRequestModel(accountType: "remitter", cnicNicop: "1231312312", paassword: "Abc12345"), service: LoginServiceNegativeMock())
        
        let outputHandler = UUIDChangeViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.resendOtpRequest()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertNotNil(outputHandler.didShowError)
        XCTAssertEqual(outputHandler.didShowError?.message, "Something unexpected happened. Please try again")
        XCTAssertEqual(outputHandler.didShowError?.title, "Oh Snap!")
        XCTAssertEqual(outputHandler.didShowError?.errorCode, 500)
    }
}


class UUIDChangeViewModelOutputHandler {
    
    var viewModel: UUIDChangeViewModel
    
    var didSetNextButtonStateEnabled: Bool = false
    var didSetNextButtonStateDisabled: Bool = false
    var didShowAlert: Bool = false
    var alert: AlertViewModel?
    var didCallShowActivityIndicator: Bool = false
    var didCallHideActivityIndicator: Bool = false
    var didShowError: APIResponseError? = nil
    var didEnableResendButton: Bool = false
    var didDisableResendButton: Bool = false
    var didSetOTPLabelError: String? = nil
    var didShowResendOTPDialog: Bool = false
    var didHideResendOTPDialog: Bool = false
    
    func reset() {
        didSetNextButtonStateEnabled = false
        didSetNextButtonStateDisabled = false
        didShowAlert = false
        didCallShowActivityIndicator = false
        didCallHideActivityIndicator = false
        didShowError = nil
        didEnableResendButton = false
        didDisableResendButton = false
        didSetOTPLabelError = nil
        didShowResendOTPDialog = false
        didHideResendOTPDialog = false
        
        alert = nil
    }
    
    init(viewModel: UUIDChangeViewModel) {
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
            case .resendOtpButtonState(let state):
                self.didEnableResendButton = state
                self.didDisableResendButton = !self.didEnableResendButton
            case .showOTPInvalidFormatError(_, let error):
                self.didSetOTPLabelError = error
            case .showResendOTPInfoView(let show):
                if show {
                    self.didShowResendOTPDialog = show
                } else {
                    self.didHideResendOTPDialog = false
                }
            case .showAlert(let alert):
                self.didShowAlert = true
                self.alert = alert
                
                alert.primaryButton.buttonAction?()
            default:
                print ("Default State")
            }
        }
    }
    
}

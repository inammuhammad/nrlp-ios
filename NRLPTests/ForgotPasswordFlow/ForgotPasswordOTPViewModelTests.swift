//
//  ForgotPasswordOTPViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 22/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class ForgotPasswordOTPViewModelTests: XCTestCase {

    var router = ForgotPasswordOTPRouterMock()

    func testDidTapVerifyButtonPositive() {
        let viewModel = ForgotPasswordOTPViewModel(with: router, forgotPasswordRequestModel: ForgotPasswordSendOTPRequest(nicNicop: "4220123123123", userType: "beneficiary"), service: ForgotPasswordServicePositiveMock())
        
        let outputHandler = ForgotPasswordOTPViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.didTapVerifyButton()
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertTrue(router.isNavigatedToNewPasswordScreen)
    }
    
    func testDidTapVerifyButtonNegative() {
        let viewModel = ForgotPasswordOTPViewModel(with: router, forgotPasswordRequestModel: ForgotPasswordSendOTPRequest(nicNicop: "4220123123123", userType: "beneficiary"), service: ForgotPasswordServiceNegativeMock())
        
        let outputHandler = ForgotPasswordOTPViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.didTapVerifyButton()
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertNotNil(outputHandler.didShowError)
        XCTAssertEqual(outputHandler.didShowError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.didShowError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.didShowError?.errorCode, 401)
        
    }
    
    func testDidTapResendOTPPositive() {
        let viewModel = ForgotPasswordOTPViewModel(with: router, forgotPasswordRequestModel: ForgotPasswordSendOTPRequest(nicNicop: "4220123123123", userType: "beneficiary"), service: ForgotPasswordServicePositiveMock())
        
        let outputHandler = ForgotPasswordOTPViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.resendOtpRequest()
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertTrue(outputHandler.didShowResendAlert)
    }
    
    func testDidTapResendOTPNegative() {
        let viewModel = ForgotPasswordOTPViewModel(with: router, forgotPasswordRequestModel: ForgotPasswordSendOTPRequest(nicNicop: "4220123123123", userType: "beneficiary"), service: ForgotPasswordServiceNegativeMock())
        
        let outputHandler = ForgotPasswordOTPViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.resendOtpRequest()
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertNotNil(outputHandler.didShowError)
        XCTAssertEqual(outputHandler.didShowError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.didShowError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.didShowError?.errorCode, 401)
        
    }
}


class ForgotPasswordOTPViewModelOutputHandler {
 
    var viewModel: NRLPOTPViewModelProtocol

    init(viewModel: NRLPOTPViewModelProtocol) {
        self.viewModel = viewModel
        setupObserver()
    }
    
    var didShowAlert: AlertViewModel? = nil
    var didShowResendAlert: Bool = false
    var didCallShowActivityIndicator: Bool = false
    var didCallHideActivityIndicator: Bool = false
    var didShowError: APIResponseError? = nil
    var didSetNextButtonStateEnabled: Bool = false
    var didSetNextButtonStateDisabled: Bool = false
    var didSetOTPInvalidFormatTextFieldError: String? = nil
    var didSetResetButtonEnabled: Bool = false
    var didSetResetButtonDisabled: Bool = false
    
    func reset() {
        didShowAlert = nil
        didShowResendAlert = false
        didCallShowActivityIndicator = false
        didCallHideActivityIndicator = false
        didShowError = nil
        didSetNextButtonStateEnabled = false
        didSetNextButtonStateDisabled = false
        didSetOTPInvalidFormatTextFieldError = nil
        didSetResetButtonEnabled = false
        didSetResetButtonDisabled = false
        
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
            case .nextButtonState(let state):
                if state {
                    self.didSetNextButtonStateEnabled = true
                } else {
                    self.didSetNextButtonStateDisabled = true
                }
            case .resendOtpButtonState(let state):
                if state {
                    self.didSetResetButtonEnabled = state
                } else {
                    self.didSetResetButtonDisabled = !state
                }
            case .showOTPInvalidFormatError(let show, let error):
                self.didSetOTPInvalidFormatTextFieldError = error
            case .showResendOTPInfoView(let show):
                if show {
                    self.didShowResendAlert = true
                } else {
                    self.didShowResendAlert = false
                }
            case .showAlert(let alertViewModel):
                self.didShowAlert = alertViewModel
            default:
                print ("Default State")
            }
        }
    }
}

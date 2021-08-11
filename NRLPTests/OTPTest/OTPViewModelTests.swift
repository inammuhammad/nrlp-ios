//
//  OTPViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 24/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class OTPViewModelTests: XCTestCase {

    let router = OTPRouterMock(navigationController: BaseNavigationController())
    
    func testFormattedNumber() {
        
        NRLPUserDefaults.shared.set(selectedLanguage: .english)
        
        var viewModel = OTPViewModel(with: router, model: getRegisterRequestMock(), service: OTPServicePositiveMock())
        
        var formattedNumber = viewModel.formattedNumber
        
        XCTAssertEqual(formattedNumber, "+92312312312")
        
        NRLPUserDefaults.shared.set(selectedLanguage: .urdu)
        
        viewModel = OTPViewModel(with: router, model: getRegisterRequestMock(), service: OTPServicePositiveMock())
        
        formattedNumber = viewModel.formattedNumber
        
        XCTAssertEqual(formattedNumber, "92312312312+")
        
        viewModel = OTPViewModel(with: router, model: getRegisterRequestMock(mobileNumber: "12312312311"), service: OTPServicePositiveMock())
        
        formattedNumber = viewModel.formattedNumber
        
        XCTAssertEqual(formattedNumber, "12312312311")
        
        NRLPUserDefaults.shared.set(selectedLanguage: .english)
    }
    
    func testGetNumber() {
        let viewModel = OTPViewModel(with: router, model: getRegisterRequestMock(), service: OTPServicePositiveMock())
        
        XCTAssertEqual(viewModel.getNumber(), "+92312312312")
    }
    
    func testResendOTPRequestPositive() {
        let viewModel = OTPViewModel(with: router, model: getRegisterRequestMock(), service: OTPServicePositiveMock())
        
        let outputHandler = OTPViewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.resendOtpRequest()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertTrue(outputHandler.didShowResendOTPDialog)
    }
    
    func testResendOTPRequestNegative() {
        
        let viewModel = OTPViewModel(with: router, model: getRegisterRequestMock(), service: OTPServiceNegativeMock())
        
        let outputHandler = OTPViewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.resendOtpRequest()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertNotNil(outputHandler.didShowError)
        XCTAssertEqual(outputHandler.didShowError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.didShowError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.didShowError?.errorCode, 401)
    }
    
    func testVerifyOTPRequestPositive() {
        let viewModel = OTPViewModel(with: router, model: getRegisterRequestMock(), service: OTPServicePositiveMock())
        
        let outputHandler = OTPViewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.didTapVerifyButton()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertTrue(router.didNavigatedToTermsAndCondition)
    }
    
    func testVerifyOTPRequestNegative() {
        let viewModel = OTPViewModel(with: router, model: getRegisterRequestMock(), service: OTPServiceNegativeMock())
        
        let outputHandler = OTPViewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.didTapVerifyButton()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertNotNil(outputHandler.didShowError)
        XCTAssertEqual(outputHandler.didShowError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.didShowError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.didShowError?.errorCode, 401)
    }
}


class OTPViewModelTestOutputHandler {
    
    var viewModel: OTPViewModel
    
    var didSetNextButtonStateEnabled: Bool = false
    var didSetNextButtonStateDisabled: Bool = false
    var didShowAlert: Bool = false
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
    }
    
    init(viewModel: OTPViewModel) {
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
                self.didShowResendOTPDialog = show
                self.didHideResendOTPDialog = !self.didShowResendOTPDialog
            case .showAlert:
                self.didShowAlert = true
            default:
                print ("Default State")
            }
        }
    }
    
}

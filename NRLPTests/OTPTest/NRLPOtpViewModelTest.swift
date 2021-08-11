//
//  NRLPOtpViewModelTest.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 28/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class NRLPOtpViewModelTest: XCTestCase {
    
    var output: NRLPOTPViewModelOutput?
//    private var router = RegistrationRouterMock()
    private var viewModel: NRLPOTPViewModelProtocol!
    
    override func setUp() {
        viewModel = NRLPOTPViewModel()
    }
    
    func testOtpPositive() {
        let outputHandler = NRLPOTPViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.otpCode = [1,1,1,1]
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
        (viewModel as? NRLPOTPViewModel)?.validateOTPString(string: (viewModel as? NRLPOTPViewModel)?.getVerificationCode() ?? "")
        XCTAssertNil(outputHandler.didSetOTPInvalidFormatTextFieldError)
        outputHandler.reset()
    }
    
    func testOtpNegative() {
        let outputHandler = NRLPOTPViewModelOutputHandler(viewModel: viewModel)
        
        //incomplete OTP
        viewModel.otpCode = [1,1,]
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
        (viewModel as? NRLPOTPViewModel)?.validateOTPString(string: (viewModel as? NRLPOTPViewModel)?.getVerificationCode() ?? "")
        XCTAssertNil(outputHandler.didSetOTPInvalidFormatTextFieldError)
        outputHandler.reset()
        
        //incomplete OTP
        viewModel.otpCode = nil
        XCTAssertFalse(outputHandler.didSetNextButtonStateEnabled)
        (viewModel as? NRLPOTPViewModel)?.validateOTPString(string: "a")
        XCTAssertNotNil(outputHandler.didSetOTPInvalidFormatTextFieldError)
        outputHandler.reset()
    }
    
    func testGetVerificationCode() {
        
        viewModel.otpCode = nil
        (viewModel as? NRLPOTPViewModel)?.validateOTPString(string: (viewModel as? NRLPOTPViewModel)?.getVerificationCode() ?? "")
        
        viewModel.otpCode = [nil]
        (viewModel as? NRLPOTPViewModel)?.validateOTPString(string: (viewModel as? NRLPOTPViewModel)?.getVerificationCode() ?? "")
    }
    
    func testDidTapResentOTPButton() {
        
        let outputHandler = NRLPOTPViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.didTapOnResendOtpButton()
        XCTAssertFalse(outputHandler.didSetResetButtonEnabled)
        XCTAssertTrue(outputHandler.didSetResetButtonDisabled)
    }
}

class NRLPOTPViewModelOutputHandler {
 
    var viewModel: NRLPOTPViewModelProtocol

    init(viewModel: NRLPOTPViewModelProtocol) {
        self.viewModel = viewModel
        setupObserver()
    }
    
    var didShowAlert: AlertViewModel? = nil
    var didShowResendAlert: Bool = false
    var didCallShowActivityIndicator: Bool = false
    var didCallHideActivityIndicator: Bool = false
    var didShowError: Error? = nil
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

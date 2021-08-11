//
//  BeneficiaryVerificationViewModelTest.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 28/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class BeneficiaryVerificationViewModelTest: XCTestCase {

    var router = BeneficiaryVerificationRouterMock()
    
    func testOTPCode() {
        let viewModel = BeneficiaryVerificationViewModel(service: BeneficiaryVerificationServicePositiveMock(), router: router, model: getRegisterRequestMock())
        
        let outputHandler = BeneficiaryVerificationViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.otpCode = [1, nil, nil, nil]
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateDisabled)
        XCTAssertFalse(outputHandler.didSetNextButtonStateEnabled)
        
        outputHandler.reset()
        
        viewModel.otpCode = [1, 0,0,0]
        
        XCTAssertFalse(outputHandler.didSetNextButtonStateDisabled)
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
    }

    func testNextButtonPressedPositive() {
        let viewModel = BeneficiaryVerificationViewModel(service: BeneficiaryVerificationServicePositiveMock(), router: router, model: getRegisterRequestMock())
        
        let outputHandler = BeneficiaryVerificationViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.otpCode = [1, 0, 0, 0]
        
        viewModel.nextButtonPressed()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertTrue(router.isNavigatedToNextScreen)
    }
    
    func testNextButtonPressedNegative() {
        var viewModel = BeneficiaryVerificationViewModel(service: BeneficiaryVerificationServiceNegativeMock(), router: router, model: getRegisterRequestMock())
        
        var outputHandler = BeneficiaryVerificationViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.otpCode = [1, 0, 0, 0]
        
        viewModel.nextButtonPressed()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertNotNil(outputHandler.didShowError)
        XCTAssertEqual(outputHandler.didShowError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.didShowError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.didShowError?.errorCode, 401)
        
        
        viewModel = BeneficiaryVerificationViewModel(service: BeneficiaryVerificationServiceNegativeMock(), router: router, model: getRegisterRequestMock())
        
        outputHandler = BeneficiaryVerificationViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.otpCode = nil
        
        viewModel.nextButtonPressed()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertNotNil(outputHandler.didShowError)
        XCTAssertEqual(outputHandler.didShowError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.didShowError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.didShowError?.errorCode, 401)
    }
    
    func testValidateOTPString() {
        let viewModel = BeneficiaryVerificationViewModel(service: BeneficiaryVerificationServicePositiveMock(), router: router, model: getRegisterRequestMock())
        
        let outputHandler = BeneficiaryVerificationViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.validateOTPString(string: "1234")
        
        XCTAssertNil(outputHandler.didSetOTPInvalidFormatTextFieldError)
        
        viewModel.validateOTPString(string: "1abs")
        
        XCTAssertNotNil(outputHandler.didSetOTPInvalidFormatTextFieldError)
        XCTAssertEqual(outputHandler.didSetOTPInvalidFormatTextFieldError, "Please enter a valid registration code")
    }
}

class BeneficiaryVerificationViewModelOutputHandler {
 
    var viewModel: BeneficiaryVerificationViewModel

    init(viewModel: BeneficiaryVerificationViewModel) {
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
    
    func reset() {
        didShowAlert = nil
        didShowResendAlert = false
        didCallShowActivityIndicator = false
        didCallHideActivityIndicator = false
        didShowError = nil
        didSetNextButtonStateEnabled = false
        didSetNextButtonStateDisabled = false
        didSetOTPInvalidFormatTextFieldError = nil
        
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
            case .showOTPInvalidFormatError(_, let error):
                self.didSetOTPInvalidFormatTextFieldError = error
            }
        }
    }
}

//
//  RemitterVerificationViewModelTest.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 28/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class RemitterVerificationViewModelTest: XCTestCase {

    var output: RemitterVerificationViewModelOutput?
    private var router = RemitterVerificationRouterMock()
    
    var commonRegisterModel = RegisterRequestModel(accountType: "remitter", cnicNicop: "1234512345671", email: "abc@abc.com", fullName: "Muhammad Ali", mobileNo: "+923215878488", paassword: "Test@1234", registrationCode: "123457890", transactionAmount: nil, transactionRefNo: nil)
    
    func testVerificationPossitive() {
        let viewModel: RemitterVerificationViewModel = RemitterVerificationViewModel(service: RemitterVerificationServicePositiveMock(), router: router, model: commonRegisterModel)
        let outputHandler = RemitterVerificationViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.referenceNumber = "123456789"
        viewModel.transactionAmount = "10000"
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
        viewModel.nextButtonPressed()
        XCTAssertNil(outputHandler.didSetReferenceNumberTextFieldError)
        XCTAssertNil(outputHandler.didSetTransactionAmountTextFieldError)
        XCTAssertTrue(router.isNavigatedToNextScreen)
    }
    
    func testVerificationNegative() {
        let viewModel: RemitterVerificationViewModel = RemitterVerificationViewModel(service: RemitterVerificationServicePositiveMock(), router: router, model: commonRegisterModel)
        let outputHandler = RemitterVerificationViewModelOutputHandler(viewModel: viewModel)
        
        // Wrong Transaction Amount
        viewModel.referenceNumber = "123456789"
        viewModel.transactionAmount = "ABC"
        
        XCTAssertFalse(outputHandler.didSetNextButtonStateEnabled)
        viewModel.nextButtonPressed()
        XCTAssertNil(outputHandler.didSetReferenceNumberTextFieldError)
        XCTAssertNotNil(outputHandler.didSetTransactionAmountTextFieldError)
        XCTAssertFalse(router.isNavigatedToNextScreen)
        
        // Reference Number Attempts
        viewModel.referenceNumber = "!@#$"
        viewModel.transactionAmount = "10000"
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
        viewModel.nextButtonPressed()
        XCTAssertNil(outputHandler.didSetTransactionAmountTextFieldError)
        XCTAssertNil(outputHandler.didSetReferenceNumberTextFieldError)
        XCTAssertTrue(router.isNavigatedToNextScreen)
        
        // Reference Number Attempts
        viewModel.referenceNumber = nil
        viewModel.transactionAmount = nil
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
        viewModel.nextButtonPressed()
        XCTAssertEqual(outputHandler.didSetTransactionAmountTextFieldError, "Enter a valid amount")
        XCTAssertEqual(outputHandler.didSetReferenceNumberTextFieldError, "Please enter a valid reference number")
        XCTAssertTrue(router.isNavigatedToNextScreen)
    }
    
    func testVerificationNegativeAPI() {
        let viewModel: RemitterVerificationViewModel = RemitterVerificationViewModel(service: RemitterVerificationServiceNegativeMock(), router: router, model: commonRegisterModel)
        let outputHandler = RemitterVerificationViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.referenceNumber = "123456789"
        viewModel.transactionAmount = "10000"
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
        viewModel.nextButtonPressed()
        XCTAssertNil(outputHandler.didSetReferenceNumberTextFieldError)
        XCTAssertNil(outputHandler.didSetTransactionAmountTextFieldError)
        XCTAssertFalse(router.isNavigatedToNextScreen)
        
        let error = outputHandler.didShowError
        XCTAssertNotNil(error)
        XCTAssertEqual(error?.message, "No Internet Connection. Check your network settings and try again.".localized)
        XCTAssertEqual(error?.title, "Connection Failed".localized)
    }
}

class RemitterVerificationViewModelOutputHandler {
    
    var viewModel: RemitterVerificationViewModel
    
    var didCallShowActivityIndicator: Bool = false
    var didCallHideActivityIndicator: Bool = false
    var didShowError: APIResponseError? = nil
    var didSetNextButtonStateEnabled: Bool = false
    var didSetNextButtonStateDisabled: Bool = false
    var didSetReferenceNumberTextFieldError: String? = nil
    var didSetTransactionAmountTextFieldError: String? = nil
    
    init(viewModel: RemitterVerificationViewModel) {
        self.viewModel = viewModel
        setupObserver()
    }
    
    func reset() {
        didCallShowActivityIndicator = false
        didCallHideActivityIndicator = false
        didShowError  = nil
        didSetNextButtonStateEnabled = false
        didSetNextButtonStateDisabled = false
        didSetReferenceNumberTextFieldError  = nil
        didSetTransactionAmountTextFieldError  = nil
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
            case .referenceNumberLabelState(let error, let message):
                self.didSetReferenceNumberTextFieldError = message
            case .transactionAmountLabelState(let error, let message):
                self.didSetTransactionAmountTextFieldError = message
            default:
                print ("Default case")
            }
        }
    }
    
}

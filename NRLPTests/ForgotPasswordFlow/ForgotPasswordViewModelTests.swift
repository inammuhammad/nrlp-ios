//
//  ForgotPasswordViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 25/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class ForgotPasswordViewModelTests: XCTestCase {

    var router = ForgotPasswordRouterMock()
    
    func testAccountTypePicker() {
        let viewModel = ForgotPasswordViewModel(router: router, service: ForgotPasswordServicePositiveMock())
        
        XCTAssertNotNil(viewModel.accountTypePickerViewModel)
        
        let accountTypeData = viewModel.accountTypePickerViewModel.data
        XCTAssertEqual(accountTypeData.count, 2)
        
        XCTAssertEqual(accountTypeData.first?.title, "Remitter")
        XCTAssertEqual(accountTypeData.first?.key, "remitter")
        
        
        XCTAssertEqual(accountTypeData.last?.title, "Beneficiary")
        XCTAssertEqual(accountTypeData.last?.key, "beneficiary")
    }
    
    func testCNIC() {
        let viewModel = ForgotPasswordViewModel(router: router, service: ForgotPasswordServicePositiveMock())
        
        let outputHandler = ForgotPasswordViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.cnic = "abc"
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateDisabled)
        
        viewModel.didSelect(accountType: viewModel.accountTypePickerViewModel.data.first as? AccountTypePickerItemModel)
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
    }
    
    func testNextButtonPressedPositive() {
        let viewModel = ForgotPasswordViewModel(router: router, service: ForgotPasswordServicePositiveMock())
        
        let outputHandler = ForgotPasswordViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.cnic = "4220112231231"
        
        viewModel.didSelect(accountType: viewModel.accountTypePickerViewModel.data.first as? AccountTypePickerItemModel)
        
        viewModel.nextButtonPressed()
        
        XCTAssertNil(outputHandler.cnicFieldError)
        
        XCTAssertNil(outputHandler.accountTypeFieldError)
        
        XCTAssertTrue(router.isNavigatedToOTPScreen)
    }
    
    func testNextButtonPressedNegative() {
        let viewModel = ForgotPasswordViewModel(router: router, service: ForgotPasswordServiceNegativeMock())
        
        let outputHandler = ForgotPasswordViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.nextButtonPressed()
        
        XCTAssertNotNil(outputHandler.cnicFieldError)
        XCTAssertEqual(outputHandler.cnicFieldError, "Please enter a valid CNIC/NICOP")
        
        XCTAssertNotNil(outputHandler.accountTypeFieldError)
        XCTAssertEqual(outputHandler.accountTypeFieldError, "Select User Type")
        
        outputHandler.reset()
        
        viewModel.cnic = "abc"
        
        viewModel.didSelect(accountType: viewModel.accountTypePickerViewModel.data.first as? AccountTypePickerItemModel)
        
        viewModel.nextButtonPressed()
        
        XCTAssertNotNil(outputHandler.cnicFieldError)
        XCTAssertEqual(outputHandler.cnicFieldError, "Please enter a valid CNIC/NICOP")
        
        XCTAssertNil(outputHandler.accountTypeFieldError)
        
        viewModel.cnic = "4220112231231"
        
        viewModel.didSelect(accountType: viewModel.accountTypePickerViewModel.data.first as? AccountTypePickerItemModel)
        
        viewModel.nextButtonPressed()
        
        XCTAssertNil(outputHandler.cnicFieldError)
        
        XCTAssertNil(outputHandler.accountTypeFieldError)
    }

}

class ForgotPasswordViewModelOutputHandler {
    
    var viewModel: ForgotPasswordViewModel
    
    var didSetNextButtonStateEnabled: Bool = false
    var didSetNextButtonStateDisabled: Bool = false
    var didCallShowActivityIndicator: Bool = false
    var didCallHideActivityIndicator: Bool = false
    var didShowError: APIResponseError? = nil
    
    var cnicFieldError: String? = nil
    var accountTypeFieldError: String? = nil
    
    var updateAccountType: String?
    
    func reset() {
        didSetNextButtonStateEnabled = false
        didSetNextButtonStateDisabled = false
        didCallShowActivityIndicator = false
        didCallHideActivityIndicator = false
        didShowError = nil
        cnicFieldError = nil
        
        accountTypeFieldError = nil
        updateAccountType = nil
    }
    
    init(viewModel: ForgotPasswordViewModel) {
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
            case .cnicTextField(_, let error):
                self.cnicFieldError = error
            case .accountTypeTextField(_, let error):
                self.accountTypeFieldError = error
            case .updateAccountType(let accountType):
                self.updateAccountType = accountType
            }
        }
    }
    
}

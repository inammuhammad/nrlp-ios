//
//  ChangePasswordViewModelTest.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 27/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class ChangePasswordViewModelTest: XCTestCase {
    
    var output: ChangePasswordViewModelOutput?
    private var service: ChangePasswordServiceProtocol!
    private var router = ChangePasswordRouterMock()
    private var viewModel: ChangePasswordViewModelProtocol!
    
    override func setUp() {
        viewModel = ChangePasswordViewModel(router: router, service: ChangePasswordServiceMock())
    }
    
    func testChangePasswordPossitive() {
        let outputHandler = ChangePasswordViewModelOutputHandler(changePasswordViewModel: viewModel)
        
        viewModel.oldPaassword = "Abc@1234"
        viewModel.paassword = "New@4321"
        viewModel.rePaassword = "New@4321"
        
        XCTAssertTrue(outputHandler.didSetDoneButtonStateEnabled)
        viewModel.doneButtonPressed()
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        XCTAssertTrue(router.isNavigatedToSuccessScreen)
        
    }
    
    func testChangePasswordNegative() {
        let outputHandler = ChangePasswordViewModelOutputHandler(changePasswordViewModel: viewModel)
        
//      Old Password wrong
        viewModel.oldPaassword = "Abc"
        viewModel.paassword = "New@4321"
        viewModel.rePaassword = "New@4321"
        
        XCTAssertTrue(outputHandler.didSetDoneButtonStateEnabled)
        viewModel.doneButtonPressed()
        XCTAssertFalse(outputHandler.didCallShowActivityIndicator)
        XCTAssertNotNil(outputHandler.didSetOldPassLabelError)
        XCTAssertNil(outputHandler.didSetNewPassLabelError)
        XCTAssertNil(outputHandler.didSetRetypePassLabelError)
        outputHandler.reset()
        
//      New Password wrong
        viewModel.oldPaassword = "Abc@1234"
        viewModel.paassword = "New@"
        viewModel.rePaassword = "New@"
        
        XCTAssertTrue(outputHandler.didSetDoneButtonStateEnabled)
        viewModel.doneButtonPressed()
        XCTAssertFalse(outputHandler.didCallShowActivityIndicator)
        XCTAssertNil(outputHandler.didSetOldPassLabelError)
        XCTAssertNotNil(outputHandler.didSetNewPassLabelError)
        XCTAssertNil(outputHandler.didSetRetypePassLabelError)
        outputHandler.reset()
        
//      New Password wrong
        viewModel.oldPaassword = "Abc@1234"
        viewModel.paassword = "New@4321"
        viewModel.rePaassword = "New@"
        
        XCTAssertTrue(outputHandler.didSetDoneButtonStateEnabled)
        viewModel.doneButtonPressed()
        XCTAssertFalse(outputHandler.didCallShowActivityIndicator)
        XCTAssertNil(outputHandler.didSetOldPassLabelError)
        XCTAssertNil(outputHandler.didSetNewPassLabelError)
        XCTAssertNotNil(outputHandler.didSetRetypePassLabelError)
    }
    
    func testValidateConfirmPassword() {
        
        let outputHandler = ChangePasswordViewModelOutputHandler(changePasswordViewModel: viewModel)
        
        viewModel.paassword = "Abc12345"
        viewModel.rePaassword = viewModel.paassword
        viewModel.validateConfirmPassword()
        XCTAssertFalse(outputHandler.didShowRePaasswordError)
        XCTAssertNil(outputHandler.didSetRetypePassLabelError)
        
        viewModel.rePaassword = "Abc"
        viewModel.validateConfirmPassword()
        XCTAssertTrue(outputHandler.didShowRePaasswordError)
        XCTAssertNotNil(outputHandler.didSetRetypePassLabelError)
        XCTAssertEqual(outputHandler.didSetRetypePassLabelError, "Both passwords do not match")
    }
}

class ChangePasswordViewModelOutputHandler {
    
    var viewModel: ChangePasswordViewModelProtocol
    
    var didSetDoneButtonStateEnabled: Bool = false
    var didSetDoneButtonStateDisabled: Bool = false
    var didCallShowActivityIndicator: Bool = false
    var didCallHideActivityIndicator: Bool = false
    var didSetOldPassLabelError: String? = nil
    var didSetNewPassLabelError: String? = nil
    var didSetRetypePassLabelError: String? = nil
    var didShowError: Error? = nil
    var didShowAlert: Bool = false
    var didShowRePaasswordError: Bool = false
    
    init(changePasswordViewModel: ChangePasswordViewModelProtocol) {
        self.viewModel = changePasswordViewModel
        setupObserver()
    }
    
    func reset() {
        didSetDoneButtonStateEnabled = false
        didSetDoneButtonStateDisabled = false
        didCallShowActivityIndicator = false
        didCallHideActivityIndicator = false
        didSetOldPassLabelError = nil
        didSetNewPassLabelError = nil
        didSetRetypePassLabelError = nil
        didShowError = nil
        didShowAlert = false
    }
    
    private func setupObserver() {
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
            case .doneButtonState(let enableState):
                if enableState {
                    self.didSetDoneButtonStateEnabled = true
                } else {
                    self.didSetDoneButtonStateDisabled = true
                }
            case .oldPasswordTextField(let _, let error):
                self.didSetOldPassLabelError = error
            case .passwordTextField(let _, let error):
                self.didSetNewPassLabelError = error
            case .rePasswordTextField(let errorState, let error):
                self.didSetRetypePassLabelError = error
                self.didShowRePaasswordError = errorState
            }
        }
    }
}

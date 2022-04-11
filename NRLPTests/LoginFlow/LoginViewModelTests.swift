//
//  LoginViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 19/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class LoginViewModelTests: XCTestCase {
    
    var router = LoginRouterMock()
    
    func testLoginButtonPressedPositive() {
        
        var loginViewModel: LoginViewModelProtocol = LoginViewModel(service:   APIKeyServiceDecorator(decoratee: LoginServicePositiveMock(), appKeyService: AppKeyServiceMock()) , router: router)
        let loginViewModelOutputHandler = LoginViewModelOutputHandler(loginViewModel: loginViewModel)
        loginViewModel.paassword = "Password@123"
        loginViewModel.cnic = "4220133573111"
        
        loginViewModel.loginButtonPressed()
        XCTAssertTrue(loginViewModelOutputHandler.didCalledShowActivityIndicator)
        XCTAssertTrue(loginViewModelOutputHandler.didCalledHideActivityIndicator)
        XCTAssertTrue(router.isNavigatedToHomeScreen)
        XCTAssertNil(loginViewModelOutputHandler.apiError)
    }
    
    func testLoginAPINegativeLocalError() {
        let loginViewModel = LoginViewModel(service: APIKeyServiceDecorator(decoratee: LoginServiceNegativeMock(), appKeyService: AppKeyServiceMock()), router: router)
        let loginViewModelOutputHandler = LoginViewModelOutputHandler(loginViewModel: loginViewModel)
        loginViewModel.paassword = "Password@123"
        loginViewModel.cnic = "4220133573111"
        loginViewModel.accountType = "beneficiary"
        loginViewModel.loginButtonPressed()
        XCTAssertTrue(loginViewModelOutputHandler.didCalledShowActivityIndicator)
        XCTAssertTrue(loginViewModelOutputHandler.didCalledHideActivityIndicator)
        XCTAssertFalse(router.isNavigatedToHomeScreen)
        XCTAssertNil(loginViewModelOutputHandler.apiError)
        XCTAssertTrue(router.isNavigatedToUUIDChangeScreen)
    }
    
    func testLoginAPINegativeServerError() {
        let loginViewModel = LoginViewModel(service: APIKeyServiceDecorator(decoratee: LoginServiceNegativeMock(), appKeyService: AppKeyServiceMock()), router: router)
        let loginViewModelOutputHandler = LoginViewModelOutputHandler(loginViewModel: loginViewModel)
        loginViewModel.paassword = "Password@123"
        loginViewModel.cnic = "4220133573111"
        
        loginViewModel.loginButtonPressed()
        XCTAssertTrue(loginViewModelOutputHandler.didCalledShowActivityIndicator)
        XCTAssertTrue(loginViewModelOutputHandler.didCalledHideActivityIndicator)
        XCTAssertFalse(router.isNavigatedToHomeScreen)
        XCTAssertNotNil(loginViewModelOutputHandler.apiError)
        XCTAssertFalse(router.isNavigatedToUUIDChangeScreen)
        
        loginViewModel.accountType = "remitter"
        let error = loginViewModelOutputHandler.apiError
        XCTAssertEqual(error?.message, "Something unexpected happened. Please try again".localized)
        XCTAssertEqual(error?.title, "Oh Snap!".localized)
    }
    
    func testLoginButtonPressedNegative() {
        var loginViewModel: LoginViewModelProtocol = LoginViewModel(service: APIKeyServiceDecorator(decoratee: LoginServicePositiveMock(), appKeyService: AppKeyServiceMock()), router: router)
        let loginViewModelOutputHandler = LoginViewModelOutputHandler(loginViewModel: loginViewModel)
        loginViewModel.cnic = "42201"
        loginViewModel.paassword = "Password@123"
        loginViewModel.loginButtonPressed()
        XCTAssertFalse(loginViewModelOutputHandler.didCalledShowActivityIndicator)
        XCTAssertFalse(loginViewModelOutputHandler.didCalledHideActivityIndicator)
        XCTAssertFalse(router.isNavigatedToHomeScreen)
        XCTAssertNotNil(loginViewModelOutputHandler.didSetCNICLabelError)
        XCTAssertEqual(loginViewModelOutputHandler.didSetCNICLabelError ?? "", "Please enter a valid CNIC/NICOP".localized)
        XCTAssertNil(loginViewModelOutputHandler.didSetPasswordError)
        
        loginViewModelOutputHandler.reset()
        
        loginViewModel.cnic = "4220133573111"
        loginViewModel.paassword = "Pass"
        loginViewModel.loginButtonPressed()
        XCTAssertFalse(loginViewModelOutputHandler.didCalledShowActivityIndicator)
        XCTAssertFalse(loginViewModelOutputHandler.didCalledHideActivityIndicator)
        XCTAssertFalse(router.isNavigatedToHomeScreen)
        XCTAssertNil(loginViewModelOutputHandler.didSetCNICLabelError)
        XCTAssertNotNil(loginViewModelOutputHandler.didSetPasswordError)
        XCTAssertEqual(loginViewModelOutputHandler.didSetPasswordError ?? "", "Please enter a valid password".localized)
    }
    
    func testRegisterButtonPressed() {
        let loginViewModel: LoginViewModelProtocol = LoginViewModel(service: APIKeyServiceDecorator(decoratee: LoginServicePositiveMock(), appKeyService: AppKeyServiceMock()), router: router)
        loginViewModel.registerButtonPreessed()
        XCTAssertTrue(router.isNavigatedToRegisterScreen)
    }
    
    func testCNIC() {
        var loginViewModel: LoginViewModelProtocol = LoginViewModel(service: APIKeyServiceDecorator(decoratee: LoginServicePositiveMock(), appKeyService: AppKeyServiceMock()), router: router)
        let loginViewModelOutputHandler = LoginViewModelOutputHandler(loginViewModel: loginViewModel)
        loginViewModel.cnic = ""
        loginViewModel.paassword = "Password@123"
        XCTAssertTrue(loginViewModelOutputHandler.didSetLoginButtonDisable)
        XCTAssertFalse(loginViewModelOutputHandler.didSetLoginButtonEnable)
        loginViewModelOutputHandler.reset()
        
        loginViewModel.cnic = "4"
        XCTAssertTrue(loginViewModelOutputHandler.didSetLoginButtonDisable)
        XCTAssertFalse(loginViewModelOutputHandler.didSetLoginButtonEnable)
        
        loginViewModelOutputHandler.reset()
        
        loginViewModel.cnic = "4220133573111"
        XCTAssertFalse(loginViewModelOutputHandler.didSetLoginButtonDisable)
        XCTAssertTrue(loginViewModelOutputHandler.didSetLoginButtonEnable)
    }
    
    func testPassword() {
        var loginViewModel: LoginViewModelProtocol = LoginViewModel(service: APIKeyServiceDecorator(decoratee: LoginServicePositiveMock(), appKeyService: AppKeyServiceMock()), router: router)
        let loginViewModelOutputHandler = LoginViewModelOutputHandler(loginViewModel: loginViewModel)
        loginViewModel.cnic = "4220133573111"
        loginViewModel.paassword = ""
        XCTAssertTrue(loginViewModelOutputHandler.didSetLoginButtonDisable)
        XCTAssertFalse(loginViewModelOutputHandler.didSetLoginButtonEnable)
        
        loginViewModelOutputHandler.reset()
        
        loginViewModel.paassword = "Passwor"
        XCTAssertTrue(loginViewModelOutputHandler.didSetLoginButtonDisable)
        XCTAssertFalse(loginViewModelOutputHandler.didSetLoginButtonEnable)
        
        loginViewModelOutputHandler.reset()
        
        loginViewModel.paassword = "Password@123"
        XCTAssertTrue(loginViewModelOutputHandler.didSetLoginButtonEnable)
        XCTAssertFalse(loginViewModelOutputHandler.didSetLoginButtonDisable)
    }
    
    func testForgotPasswordPressed() {
        let loginViewModel: LoginViewModelProtocol = LoginViewModel(service: APIKeyServiceDecorator(decoratee: LoginServicePositiveMock(), appKeyService: AppKeyServiceMock()), router: router)
        loginViewModel.forgotPasswordPressed()
        XCTAssertTrue(router.isNavigatedToForgotPasswordScreen)
    }
    
    func testResetData() {
        
    }
    
    func testAccountType() {
        
    }
}

class LoginViewModelOutputHandler {
    
    var loginViewModel: LoginViewModelProtocol
    
    var didCalledShowActivityIndicator: Bool = false
    var didCalledHideActivityIndicator: Bool = false
    var apiError: APIResponseError? = nil
    var didSetLoginButtonEnable: Bool = false
    var didSetLoginButtonDisable: Bool = false
    var didSetCNICLabelError: String? = nil
    var didSetPasswordError: String? = nil
    
    init(loginViewModel: LoginViewModelProtocol) {
        self.loginViewModel = loginViewModel
        setupObserver()
    }
    
    func reset() {
        didCalledShowActivityIndicator = false
        didCalledHideActivityIndicator = false
        apiError = nil
        didSetLoginButtonEnable = false
        didSetLoginButtonDisable = false
        didSetCNICLabelError = nil
        didSetPasswordError = nil
    }
    
    private func setupObserver() {
        loginViewModel.output = { output in
            switch output {
            case .showActivityIndicator(let show):
                if show {
                    self.didCalledShowActivityIndicator = true
                } else {
                    self.didCalledHideActivityIndicator = true
                }
                
            case .showError(let error):
                self.apiError = error
            case .loginButtonState(let state):
                if state {
                    self.didSetLoginButtonEnable = true
                } else {
                    self.didSetLoginButtonDisable = true
                }
            case .cnicLabelState(_, let errorMsg):
                self.didSetCNICLabelError = errorMsg
            case .passwordLabelState(_, let errorMsg):
                self.didSetPasswordError = errorMsg
//            case .jailBroken:
//                break
            }
        }
    }
}

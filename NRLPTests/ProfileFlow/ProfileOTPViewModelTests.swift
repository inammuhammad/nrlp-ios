//
//  ProfileOTPViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 22/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class ProfileOTPViewModelTests: XCTestCase {

    var router = ProfileOTPRouterMock(navigationController: BaseNavigationController())

    override func tearDown() {
        NRLPUserDefaults.shared.set(selectedLanguage: .english)
    }
    
    func testFormattedNumber() {
        var viewModel = ProfileOTPViewModel(with: router, model: ProfileUpdateModel(profileUpdateRequestModel: UpdateProfileSendOTPRequestModel(email: "rahim@gmail.com", mobileNumber: "0093428031551"), userModel: getMockUser()), service: UserProfileServicePositiveMock())
        
        var number = viewModel.localizedFormattedNumber
        
        XCTAssertEqual(number, "0093428031551")
        
        viewModel = ProfileOTPViewModel(with: router, model: ProfileUpdateModel(profileUpdateRequestModel: UpdateProfileSendOTPRequestModel(email: "rahim@gmail.com", mobileNumber: "+93428031551"), userModel: getMockUser()), service: UserProfileServicePositiveMock())
        
        number = viewModel.localizedFormattedNumber
        
        XCTAssertEqual(number, "+93428031551")
        
        NRLPUserDefaults.shared.set(selectedLanguage: .urdu)
        
        viewModel = ProfileOTPViewModel(with: router, model: ProfileUpdateModel(profileUpdateRequestModel: UpdateProfileSendOTPRequestModel(email: "rahim@gmail.com", mobileNumber: "+93428031551"), userModel: getMockUser()), service: UserProfileServicePositiveMock())
        
        number = viewModel.localizedFormattedNumber
        
        XCTAssertEqual(number, "93428031551+")
    }
    
    func testResendOTPPositive() {
        let viewModel = ProfileOTPViewModel(with: router, model: ProfileUpdateModel(profileUpdateRequestModel: UpdateProfileSendOTPRequestModel(email: "rahim@gmail.com", mobileNumber: "0093428031551"), userModel: getMockUser()), service: UserProfileServicePositiveMock())
        
        let outputHandler = ProfileOTPViewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.resendOtpRequest()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        XCTAssertTrue(outputHandler.didShowResendOTPDialog)
        
    }
    
    func testResendOTPNegative() {
        let viewModel = ProfileOTPViewModel(with: router, model: ProfileUpdateModel(profileUpdateRequestModel: UpdateProfileSendOTPRequestModel(email: "rahim@gmail.com", mobileNumber: "0093428031551"), userModel: getMockUser()), service: UserProfileServiceNegativeMock())
        
        let outputHandler = ProfileOTPViewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.resendOtpRequest()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        XCTAssertNotNil(outputHandler.didShowError)
        XCTAssertEqual(outputHandler.didShowError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.didShowError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.didShowError?.errorCode, 401)
    }
    
    func testGetNumber() {
        let viewModel = ProfileOTPViewModel(with: router, model: ProfileUpdateModel(profileUpdateRequestModel: UpdateProfileSendOTPRequestModel(email: "rahim@gmail.com", mobileNumber: "0093428031551"), userModel: getMockUser()), service: UserProfileServiceNegativeMock())
        
        XCTAssertEqual(viewModel.getNumber(), "0093428031551")
    }
    
    func testVerifyOTPPositive() {
        let viewModel = ProfileOTPViewModel(with: router, model: ProfileUpdateModel(profileUpdateRequestModel: UpdateProfileSendOTPRequestModel(email: "rahim@gmail.com", mobileNumber: "0093428031551"), userModel: getMockUser()), service: UserProfileServicePositiveMock())
        
        let outputHandler = ProfileOTPViewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.didTapVerifyButton()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        XCTAssertTrue(router.didNavigatedToSuccess)
        
    }
    
    func testVerifyOTPNegative() {
        let viewModel = ProfileOTPViewModel(with: router, model: ProfileUpdateModel(profileUpdateRequestModel: UpdateProfileSendOTPRequestModel(email: "rahim@gmail.com", mobileNumber: "0093428031551"), userModel: getMockUser()), service: UserProfileServiceNegativeMock())
        
        let outputHandler = ProfileOTPViewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.didTapVerifyButton()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        XCTAssertNotNil(outputHandler.didShowError)
        XCTAssertEqual(outputHandler.didShowError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.didShowError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.didShowError?.errorCode, 401)
    }
}

class ProfileOTPViewModelTestOutputHandler {
    
    var viewModel: ProfileOTPViewModel
    
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
    
    init(viewModel: ProfileOTPViewModel) {
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

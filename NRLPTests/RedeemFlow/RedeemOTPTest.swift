//
//  RedeemOTPTest.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 03/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class RedeemOTPTest: XCTestCase {

    private var router = RedeemOTPRouterMock()
    private var service: RedeemService!
    private var transactionData: String!
    private var partner: Partner!
    private var user: UserModel!
    
    var commonPartner = Partner(id: 1, partnerName: "TEST PARTNER", categories: [Category(id: 1, categoryName: "New Ticket", pointsAssigned: 8000), Category(id: 2, categoryName: "Renew Ticket", pointsAssigned: 200)])
    
    private var commonUserModel: UserModel!
    
    override func setUp() {
        
        commonUserModel = getMockUser()
    }
    
    func testRedeemOTPPositive() {
        
        let viewModel = RedeemOTPViewModel(with: router, transactionId: "1234", partner: commonPartner, service: RedeemServicePositiveMock(), user: commonUserModel)
        
         let outputHandler = RedeemOTPTestOutputHandler(viewModel: viewModel)
        
        viewModel.otpCode = [0,0,0,0]
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
        viewModel.verifyOTP()
        XCTAssertNil(outputHandler.didSetOTPLabelError)
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        XCTAssertTrue(router.isNavigatedToAgentScreen)
    }
    
    func testRedeemOTPNegative() {
        
        let viewModel = RedeemOTPViewModel(with: router, transactionId: "1234", partner: commonPartner, service: RedeemServiceNegativeMock(), user: commonUserModel)
        
        let outputHandler = RedeemOTPTestOutputHandler(viewModel: viewModel)

        viewModel.otpCode = [1, nil, nil, nil]
        XCTAssertFalse(outputHandler.didSetNextButtonStateEnabled)
        
        viewModel.otpCode = [1, 1, 1, 1]
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
        viewModel.verifyOTP()
        XCTAssertNil(outputHandler.didSetOTPLabelError)
        XCTAssertFalse(outputHandler.didShowAlert)
        XCTAssertNotNil(outputHandler.didShowError)
        XCTAssertEqual(outputHandler.didShowError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.didShowError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.didShowError?.errorCode, 401)
    }
    
    func testFormatNumber() {
        
        let viewModel = RedeemOTPViewModel(with: router, transactionId: "1234", partner: commonPartner, service: RedeemServicePositiveMock(), user: commonUserModel)
        
        XCTAssertEqual(viewModel.formattedNumber, "+923215878488")
    }
    
    func testUserMobileNumber() {
        
        let viewModel = RedeemOTPViewModel(with: router, transactionId: "1234", partner: commonPartner, service: RedeemServicePositiveMock(), user: commonUserModel)
        
        XCTAssertEqual(viewModel.userNumber, "+923215878488")
    }
    
    func testAgentConfirmationScreenRouting() {
        
        let viewModel = RedeemOTPViewModel(with: router, transactionId: "1234", partner: commonPartner, service: RedeemServicePositiveMock(), user: commonUserModel)
        
        viewModel.goToAgentConfirmation()
        
        XCTAssertTrue(router.isNavigatedToAgentScreen)
    }
    
    func testResendOTPPositive() {
        
        let viewModel = RedeemOTPViewModel(with: router, transactionId: "1234", partner: commonPartner, service: RedeemServicePositiveMock(), user: commonUserModel)
        
         let outputHandler = RedeemOTPTestOutputHandler(viewModel: viewModel)
        
        viewModel.resendOtpRequest()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        XCTAssertFalse(router.isNavigatedToAgentScreen)
        XCTAssertTrue(outputHandler.didShowResendOTPDialog)
    }
    
    func testResendOTPNegative() {
        
        let viewModel = RedeemOTPViewModel(with: router, transactionId: "1234", partner: commonPartner, service: RedeemServiceNegativeMock(), user: commonUserModel)
        
        let outputHandler = RedeemOTPTestOutputHandler(viewModel: viewModel)

        viewModel.resendOtpRequest()
        XCTAssertNotNil(outputHandler.didShowError)
        XCTAssertEqual(outputHandler.didShowError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.didShowError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.didShowError?.errorCode, 401)
    }
}

class RedeemOTPTestOutputHandler {
    
    var viewModel: RedeemOTPViewModel
    
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
    
    init(viewModel: RedeemOTPViewModel) {
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

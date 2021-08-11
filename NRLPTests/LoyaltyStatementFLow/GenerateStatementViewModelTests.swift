//
//  LoyaltyStatementViewModelTests.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 26/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class GenerateStatementViewModelTests: XCTestCase {

    private var router = GenerateStatementRouterMock()
    var output: GenerateStatementViewModelOutput?

    private var commonUserModel: UserModel!
    
    override func setUp() {
        
        commonUserModel = getMockUser()
    }
    
    func testGenerateStatementPositive() {
        
        let generateStatementViewModel = GenerateStatementViewModel(userModel: commonUserModel, router: router, service: LoyaltyPointsServicePositiveMock())
        
        let generateStatementViewModelOutputHandler = GenerateStatementViewModelOutputHandler(generateStatementViewModel: generateStatementViewModel)
        
        
        
        generateStatementViewModel.email = "abc@abc.com"
        let today = Date()
        generateStatementViewModel.toDate = Calendar.current.date(byAdding: .day, value: -1, to: today)
        generateStatementViewModel.fromDate = Calendar.current.date(byAdding: .day, value: -7, to: today)
        
        XCTAssertTrue(generateStatementViewModelOutputHandler.didSetNextButtonStateEnabled)
        generateStatementViewModel.nextButtonPressed()
        XCTAssertTrue(generateStatementViewModelOutputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(generateStatementViewModelOutputHandler.didCallHideActivityIndicator)
        XCTAssertTrue(router.isNavigatedToSuccessScreen)
        
    }
    
    func testGenerateStatementNegative() {
        
        let generateStatementViewModel = GenerateStatementViewModel(userModel: commonUserModel, router: router, service: LoyaltyPointsServiceNegativeMock())
        
        let generateStatementViewModelOutputHandler = GenerateStatementViewModelOutputHandler(generateStatementViewModel: generateStatementViewModel)
        
        var today = Date()
        
        // invalid to date
        generateStatementViewModel.email = "abc@abc.com"
        generateStatementViewModel.toDate = nil
        generateStatementViewModel.fromDate = Calendar.current.date(byAdding: .day, value: -1, to: today)
        XCTAssertTrue(generateStatementViewModelOutputHandler.didSetNextButtonStateDisabled)
        generateStatementViewModel.nextButtonPressed()
        XCTAssertNotNil(generateStatementViewModelOutputHandler.didSetToDateLabelError)
        XCTAssertNil(generateStatementViewModelOutputHandler.didSetFromDateLabelError)
        XCTAssertNil(generateStatementViewModelOutputHandler.didSetEmailLabelError)
        generateStatementViewModelOutputHandler.reset()
        
        
        // invalid from date
        generateStatementViewModel.email = "abc@abc.com"
        generateStatementViewModel.toDate = Calendar.current.date(byAdding: .day, value: -1, to: today)
        generateStatementViewModel.fromDate = nil
        XCTAssertTrue(generateStatementViewModelOutputHandler.didSetNextButtonStateDisabled)
        generateStatementViewModel.nextButtonPressed()
        XCTAssertNil(generateStatementViewModelOutputHandler.didSetToDateLabelError)
        XCTAssertNotNil(generateStatementViewModelOutputHandler.didSetFromDateLabelError)
        XCTAssertNil(generateStatementViewModelOutputHandler.didSetEmailLabelError)
        generateStatementViewModelOutputHandler.reset()
        
        // invalid email
        generateStatementViewModel.email = "abc"
        generateStatementViewModel.toDate = Calendar.current.date(byAdding: .day, value: -1, to: today)
        generateStatementViewModel.fromDate = Calendar.current.date(byAdding: .day, value: -7, to: today)
        XCTAssertTrue(generateStatementViewModelOutputHandler.didSetNextButtonStateDisabled)
        generateStatementViewModel.nextButtonPressed()
        XCTAssertNil(generateStatementViewModelOutputHandler.didSetFromDateLabelError)
        XCTAssertNil(generateStatementViewModelOutputHandler.didSetToDateLabelError)
        XCTAssertNotNil(generateStatementViewModelOutputHandler.didSetEmailLabelError)
        generateStatementViewModelOutputHandler.reset()
        
        // invalid email & all dates
        generateStatementViewModel.email = "abc"
        generateStatementViewModel.toDate = nil
        generateStatementViewModel.fromDate = nil
        XCTAssertTrue(generateStatementViewModelOutputHandler.didSetNextButtonStateDisabled)
        generateStatementViewModel.nextButtonPressed()
        XCTAssertNotNil(generateStatementViewModelOutputHandler.didSetEmailLabelError)
        XCTAssertNotNil(generateStatementViewModelOutputHandler.didSetToDateLabelError)
        XCTAssertNotNil(generateStatementViewModelOutputHandler.didSetEmailLabelError)
        generateStatementViewModelOutputHandler.reset()
        
        // invalid email & all dates
        generateStatementViewModel.email = "abc@abc.com"
        generateStatementViewModel.toDate = Calendar.current.date(byAdding: .day, value: -1, to: today)
        generateStatementViewModel.fromDate = Calendar.current.date(byAdding: .day, value: 0, to: today)
        XCTAssertTrue(generateStatementViewModelOutputHandler.didSetNextButtonStateDisabled)
        generateStatementViewModel.nextButtonPressed()
        XCTAssertNil(generateStatementViewModelOutputHandler.didSetEmailLabelError)
        XCTAssertNil(generateStatementViewModelOutputHandler.didSetToDateLabelError)
        XCTAssertNil(generateStatementViewModelOutputHandler.didSetEmailLabelError)
        XCTAssertNotNil(generateStatementViewModelOutputHandler.didSetFromDateLabelError)
        generateStatementViewModelOutputHandler.reset()
        
        
        generateStatementViewModel.email = "abc@abc.com"
        
        generateStatementViewModel.toDate = Calendar.current.date(byAdding: .day, value: -1, to: today)
        generateStatementViewModel.fromDate = Calendar.current.date(byAdding: .day, value: -7, to: today)
        
        XCTAssertTrue(generateStatementViewModelOutputHandler.didSetNextButtonStateEnabled)
        generateStatementViewModel.nextButtonPressed()
        
        XCTAssertTrue(generateStatementViewModelOutputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(generateStatementViewModelOutputHandler.didCallHideActivityIndicator)
        XCTAssertFalse(router.isNavigatedToSuccessScreen)
        XCTAssertTrue(generateStatementViewModelOutputHandler.didShowAlert)
        XCTAssertNotNil(generateStatementViewModelOutputHandler.didShowError)
        XCTAssertEqual(generateStatementViewModelOutputHandler.didShowError?.errorCode, 401)
        XCTAssertEqual(generateStatementViewModelOutputHandler.didShowError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(generateStatementViewModelOutputHandler.didShowError?.title, "Connection Failed")
    }
    
    func testEmail() {
        
        let generateStatementViewModel = GenerateStatementViewModel(userModel: commonUserModel, router: router, service: LoyaltyPointsServicePositiveMock())
        
        let generateStatementViewModelOutputHandler = GenerateStatementViewModelOutputHandler(generateStatementViewModel: generateStatementViewModel)
        
        generateStatementViewModel.email = "abc"
        XCTAssertTrue(generateStatementViewModelOutputHandler.didSetNextButtonStateDisabled)
        generateStatementViewModel.nextButtonPressed()
        XCTAssertNotNil(generateStatementViewModelOutputHandler.didSetEmailLabelError)
        generateStatementViewModelOutputHandler.reset()
        
        generateStatementViewModel.email = "123@"
        XCTAssertTrue(generateStatementViewModelOutputHandler.didSetNextButtonStateDisabled)
        generateStatementViewModel.nextButtonPressed()
        XCTAssertNotNil(generateStatementViewModelOutputHandler.didSetEmailLabelError)
        generateStatementViewModelOutputHandler.reset()
    }
    
    func testDatePickerViewModel() {
        
        let generateStatementViewModel = GenerateStatementViewModel(userModel: commonUserModel, router: router, service: LoyaltyPointsServicePositiveMock())
        
        let datePickerViewModel = generateStatementViewModel.datePickerViewModel
        
        let dateString = "2020-01-01"
        let date = DateFormat().formatDate(dateString: dateString, formatter: .reverseYearMonthDayFormat)
        
        XCTAssertNotNil(datePickerViewModel)
        XCTAssertEqual(datePickerViewModel.minDate, date)
    }
    
    func testViewModelDidLoad() {
        let generateStatementViewModel = GenerateStatementViewModel(userModel: commonUserModel, router: router, service: LoyaltyPointsServicePositiveMock())
        
        let generateStatementViewModelOutputHandler = GenerateStatementViewModelOutputHandler(generateStatementViewModel: generateStatementViewModel)
        
        generateStatementViewModel.viewModelDidLoad()
        XCTAssertTrue(generateStatementViewModelOutputHandler.didSetUserEmail)
        XCTAssertNotNil(generateStatementViewModelOutputHandler.userEmail)
        XCTAssertEqual(generateStatementViewModelOutputHandler.userEmail, "aqib@test.com")
    }
}

class GenerateStatementViewModelOutputHandler {
    var generateStatementViewModel: GenerateStatementViewModelProtocol
    
    var didSetNextButtonStateEnabled: Bool = false
    var didSetNextButtonStateDisabled: Bool = false
    var didSetEmailLabelError: String? = nil
    var didSetFromDateLabelError: String? = nil
    var didSetToDateLabelError: String? = nil
    var didShowAlert: Bool = false
    var didCallShowActivityIndicator: Bool = false
    var didCallHideActivityIndicator: Bool = false
    var didShowError: APIResponseError? = nil
    var didSetUserEmail: Bool = false
    var userEmail: String?
    
    init(generateStatementViewModel: GenerateStatementViewModelProtocol) {
        self.generateStatementViewModel = generateStatementViewModel
        setupObserver()
    }
    
    func reset() {
        didSetNextButtonStateEnabled = false
        didSetNextButtonStateDisabled = false
        didSetEmailLabelError  = nil
        didShowAlert = false
        didCallShowActivityIndicator = false
        didCallHideActivityIndicator = false
        didShowError  = nil
    }
    
    private func setupObserver() {
        generateStatementViewModel.output = { output in
            switch output {
            case .showError(let error):
                self.didShowError = error
                self.didShowAlert = true
            case .showActivityIndicator(let show):
                if show {
                    self.didCallShowActivityIndicator = true
                } else {
                    self.didCallHideActivityIndicator = true
                }
            case .nextButtonState(let enableState):
                if enableState {
                    self.didSetNextButtonStateEnabled = true
                } else {
                    self.didSetNextButtonStateDisabled = true
                }
            case .emailTextField(let errorState, let error):
                self.didSetEmailLabelError = error
            case .toDateTextField(let errorState, let error):
                self.didSetToDateLabelError = error
            case .fromDateTextField(let errorState, let error):
                self.didSetFromDateLabelError = error
            case .setUserEmail(let email):
                self.userEmail = email
                self.didSetUserEmail = true
            default:
                print ("default")
            }
        }
    }
}

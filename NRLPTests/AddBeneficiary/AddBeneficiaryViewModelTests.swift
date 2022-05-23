//
//  AddBeneficiaryViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 25/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class AddBeneficiaryViewModelTests: XCTestCase {

    var router = AddBeneficiaryRouterMock(navigationController: BaseNavigationController())

    func testOpenCountryPicker() {
        let viewModel = AddBeneficiaryViewModel(router: router, service: ManageBeneficiaryServicePositiveMock())
        
        let outputHandler = AddBeneficiaryViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.openCountryPicker()
        
        XCTAssertNotNil(outputHandler.updatedPlaceHolder)
        XCTAssertEqual(outputHandler.updatedPlaceHolder, "xxxxxxxxxx")
        XCTAssertNotNil(outputHandler.updateCountry)
        XCTAssertEqual(outputHandler.updateCountry, "Pakistan")
    }
    
    func testSetName() {
        let viewModel = AddBeneficiaryViewModel(router: router, service: ManageBeneficiaryServicePositiveMock())
        
        let outputHandler = AddBeneficiaryViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.name = nil
        viewModel.cnic = nil
        viewModel.mobileNumber = nil
        
        XCTAssertTrue(outputHandler.disableAddButton)
        
        outputHandler.reset()
        
        viewModel.name = ""
        viewModel.cnic = ""
        viewModel.mobileNumber = ""
        
        XCTAssertTrue(outputHandler.disableAddButton)
        
        outputHandler.reset()
        
        viewModel.name = "a"
        viewModel.cnic = "4"
        viewModel.mobileNumber = "222"
        
        XCTAssertTrue(outputHandler.enableAddButton)
        
        outputHandler.reset()
    }
    
    func testAddButtonPositive() {
        let viewModel = AddBeneficiaryViewModel(router: router, service: ManageBeneficiaryServicePositiveMock())
        
        let outputHandler = AddBeneficiaryViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.name = "Rahim"
        viewModel.cnic = "4220133573111"
        viewModel.mobileNumber = "3428031550"
        viewModel.openCountryPicker()
        viewModel.addButtonPressed()
        
        XCTAssertTrue(outputHandler.showActivityIndicator)
        
        XCTAssertTrue(outputHandler.hideActivityIndicator)
        XCTAssertNotNil(outputHandler.showAlert)
        
        XCTAssertEqual(outputHandler.showAlert?.alertTitle, "Beneficiary Added")
        XCTAssertEqual(outputHandler.showAlert?.alertDescription, "Beneficiary created successfully; we have sent an SMS to the Beneficiary with SDRP Link to download & Registration Code. Kindly ask your beneficiary to register within 3 days before the code expiry.")
        
        outputHandler.showAlert?.primaryButton.buttonAction?()
        
        XCTAssertTrue(router.navigateToPopScreen)
    }
    
    func testAddButtonNegative() {
        let viewModel = AddBeneficiaryViewModel(router: router, service: ManageBeneficiaryServiceNegativeMock())
        
        let outputHandler = AddBeneficiaryViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.addButtonPressed()
        
        XCTAssertNotNil(outputHandler.nameError)
        XCTAssertNotNil(outputHandler.cnicError)
        XCTAssertNotNil(outputHandler.mobileNumberError)
        
        outputHandler.reset()
        
        viewModel.name = "Rahim"
        viewModel.cnic = "4220133573111"
        viewModel.mobileNumber = "3428031550"
        viewModel.openCountryPicker()
        viewModel.addButtonPressed()
        
        XCTAssertNotNil(outputHandler.showError)
        XCTAssertEqual(outputHandler.showError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.showError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.showError?.errorCode, 401)
    }
    
}

class AddBeneficiaryViewModelOutputHandler {
    
    var viewModel: AddBeneficiaryViewModel
    
    var showError: APIResponseError?
    var enableAddButton: Bool = false
    var disableAddButton: Bool = false
    
    var nameError: String?
    var cnicError: String?
    
    var mobileNumberError: String?
    
    var showAlert: AlertViewModel?
    
    var showActivityIndicator: Bool = false
    var hideActivityIndicator: Bool = false
    
    var updateMobileCode: String?
    
    var updatedPlaceHolder: String?
    var placeHolderLength: Int?
    
    var updateCountry: String?
    
    
    func reset() {
    }
    
    init(viewModel: AddBeneficiaryViewModel) {
        self.viewModel = viewModel
        setupObeserver()
    }
    
    func setupObeserver() {
        viewModel.output = { output in
            
            switch output {
                
            case .showError(let error):
                self.showError = error
            case .addButtonState(let enableState):
                if enableState {
                    self.enableAddButton = true
                } else {
                    self.disableAddButton = true
                }
            case .nameTextField( _, let errorMessage):
                self.nameError = errorMessage
            case .cnicTextField( _, let errorMessage):
                self.cnicError = errorMessage
            case .mobileNumberTextField( _, let errorMessage):
                self.mobileNumberError = errorMessage
            case .showAlert(let alert):
                self.showAlert = alert
            case .showActivityIndicator(let show):
                if show {
                    self.showActivityIndicator = true
                } else {
                    self.hideActivityIndicator = true
                }
            case .updateMobileCode(let code):
                self.updateMobileCode = code
            case .updateMobilePlaceholder(let placeholder, let length):
                self.updatedPlaceHolder = placeholder
                self.placeHolderLength = length
            case .updateCountry(let countryName):
                self.updateCountry = countryName
            }
        }
    }
}

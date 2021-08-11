//
//  BeneficiaryInfoViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 22/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class BeneficiaryInfoViewModelTests: XCTestCase {

    var router = BeneficiaryInfoRouterMock(navigationController: BaseNavigationController())
    
    func testDeleteButtonPressedPositive() {
        let viewModel = BeneficiaryInfoViewModel(router: router, beneficiary: getMockBeneficiary(), service: ManageBeneficiaryServicePositiveMock())
        let outputHandler = BeneficiaryInfoOutputHandler(ViewModel: viewModel)
        
        viewModel.deleteButtonPressed()
        
        XCTAssertNotNil(outputHandler.didShowAlert)
        XCTAssertEqual(outputHandler.didShowAlert?.alertDescription, "Are you sure you want to delete Test ?")
        XCTAssertEqual(outputHandler.didShowAlert?.alertTitle, "Delete Beneficiary")
        
        XCTAssertTrue(outputHandler.showActivityIndicator)
        XCTAssertTrue(outputHandler.hideActivityIndicator)
        
        XCTAssertTrue(router.popToBeneficiaryInfo)
    }
    
    func testDeleteButtonPressedNegative() {
        let viewModel = BeneficiaryInfoViewModel(router: router, beneficiary: getMockBeneficiary(), service: ManageBeneficiaryServiceNegativeMock())
        let outputHandler = BeneficiaryInfoOutputHandler(ViewModel: viewModel)
        
        viewModel.deleteButtonPressed()
        
        XCTAssertNotNil(outputHandler.didShowAlert)
        XCTAssertEqual(outputHandler.didShowAlert?.alertDescription, "Are you sure you want to delete Test ?")
        XCTAssertEqual(outputHandler.didShowAlert?.alertTitle, "Delete Beneficiary")
        
        XCTAssertTrue(outputHandler.showActivityIndicator)
        XCTAssertTrue(outputHandler.hideActivityIndicator)
        
        XCTAssertNotNil(outputHandler.didShowError)
        XCTAssertEqual(outputHandler.didShowError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.didShowError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.didShowError?.errorCode, 401)
    }
}

class BeneficiaryInfoOutputHandler {
    var didShowError: APIResponseError? = nil
    var deleteButtonStateEnable: Bool = false
    var didShowAlert: AlertViewModel? = nil
    var showActivityIndicator: Bool = false
    var hideActivityIndicator: Bool = false
    
    var viewModel: BeneficiaryInfoViewModel

    init(ViewModel: BeneficiaryInfoViewModel) {
        self.viewModel = ViewModel
        setupObserver()
    }
    
    func reset() {
        didShowError = nil
        deleteButtonStateEnable = false
        didShowAlert = nil
        showActivityIndicator = false
        hideActivityIndicator = false
    }
    
    private func setupObserver() {
        viewModel.output = { output in
            switch output {
            case .showError(let error):
                self.didShowError = error
            case .deleteButtonState:
                break
            case .showAlert(let alert):
                self.didShowAlert = alert
                alert.primaryButton.buttonAction?()
            case .dismissAlert:
                break
            case .showActivityIndicator(let show):
                if show {
                    self.showActivityIndicator = true
                } else {
                    self.hideActivityIndicator = true
                }
            }
        }
    }
}

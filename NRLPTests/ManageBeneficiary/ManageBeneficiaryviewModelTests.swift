//
//  ManageBeneficiaryviewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 22/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class ManageBeneficiaryviewModelTests: XCTestCase {

    var router = ManageBeneficiaryRouterMock(navigationController: BaseNavigationController())

    func testViewModelWillAppearPositive() {
        
        let service = ManageBeneficiaryServicePositiveMock()
        let viewModel = ManageBeneficiaryViewModel(with: service, router: router, user: getMockUser())
        
        let outputHandler = ManageBeneficiaryViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.viewModelWillAppear()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        XCTAssertTrue(outputHandler.didReloadData)
        XCTAssertTrue(outputHandler.showTableData)
        XCTAssertTrue(outputHandler.showAddButton)
        
        XCTAssertEqual(viewModel.numberOfRows, 1)
        XCTAssertEqual(viewModel.getBeneficiary(at: 0).alias, "Test")
        XCTAssertEqual(viewModel.getBeneficiary(at: 0).beneficiaryId, 1234)
        XCTAssertEqual(viewModel.getBeneficiary(at: 0).formattedCNIC, "1")
        XCTAssertEqual(viewModel.getBeneficiary(at: 0).mobileNo, "03428031559")
        XCTAssertEqual(viewModel.getBeneficiary(at: 0).nicNicop, 1)
        
        service.noBeneficiaryWorking = true
        
        viewModel.viewModelWillAppear()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        XCTAssertTrue(outputHandler.didReloadData)
        XCTAssertTrue(outputHandler.hideTableData)
        XCTAssertTrue(outputHandler.showAddButton)
        
        service.noBeneficiaryWorking = false
        service.beneficiaryCountGreater = true
        
        viewModel.viewModelWillAppear()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        XCTAssertTrue(outputHandler.didReloadData)
        XCTAssertTrue(outputHandler.showTableData)
        XCTAssertTrue(outputHandler.hideAddButton)
    }
    
    func testViewModelWillAppear() {
        let viewModel = ManageBeneficiaryViewModel(with: ManageBeneficiaryServiceNegativeMock(), router: router, user: getMockUser())
        
        let outputHandler = ManageBeneficiaryViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.viewModelWillAppear()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        XCTAssertNotNil(outputHandler.didShowAlert)
        XCTAssertEqual(outputHandler.didShowAlert?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.didShowAlert?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.didShowAlert?.errorCode, 401)
    }
    
    func testDidSelectedBeneficiary() {
        let viewModel = ManageBeneficiaryViewModel(with: ManageBeneficiaryServicePositiveMock(), router: router, user: getMockUser())
        
        viewModel.viewModelWillAppear()
        
        viewModel.didSelectedBeneficiary(indexPath: IndexPath(row: 0, section: 0))
        XCTAssertTrue(router.didMoveToInfoScreen)
    }
    
    func testAddBeneficiaryButton() {
        let viewModel = ManageBeneficiaryViewModel(with: ManageBeneficiaryServiceNegativeMock(), router: router, user: getMockUser())
        
        viewModel.addBeneficiaryClicked()
        
        XCTAssertTrue(router.didMoveToAddScreen)
    }
}

class ManageBeneficiaryViewModelOutputHandler {
 
    var viewModel: ManageBeneficiaryViewModel

    init(viewModel: ManageBeneficiaryViewModel) {
        self.viewModel = viewModel
        setupObserver()
    }
    
    var didShowAlert: APIResponseError? = nil
    var didCallShowActivityIndicator: Bool = false
    var didCallHideActivityIndicator: Bool = false
    var didReloadData: Bool = false
    var showAddButton: Bool = false
    var hideAddButton: Bool = false
    var showTableData: Bool = false
    var hideTableData: Bool = false
    
    func reset() {
        didShowAlert = nil
        didCallShowActivityIndicator = false
        didCallHideActivityIndicator = false
        showAddButton = false
        hideAddButton = false
        showTableData = false
        hideTableData = false
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
                self.didShowAlert = error
            case .addButton(let state):
                if state {
                    self.showAddButton = true
                } else {
                    self.hideAddButton = true
                }
            case .reloadBeneficiaries:
                self.didReloadData = true
            case .tableVisibility(let show):
                if show {
                    self.showTableData = true
                } else {
                    self.hideTableData = true
                }
            }
        }
    }
}

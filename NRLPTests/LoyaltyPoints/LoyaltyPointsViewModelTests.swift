//
//  LoyaltyPointsViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 25/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class LoyaltyPointsViewModelTests: XCTestCase {

    var router = LoyaltyPointsRouterMock(navigationController: BaseNavigationController())
    
    func testViewModelDidLoadPositive() {
        var viewModel = LoyaltyPointsViewModel(router: router, userModel: getMockUser(), service: LoyaltyPointsServicePositiveMock())
        
        var outputHandler = LoyaltyPointsViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.viewModelDidLoad()
        
        XCTAssertNotNil(outputHandler.updateLoyaltyCard)
        XCTAssertEqual(outputHandler.updateLoyaltyCard?.formattedPoints, "1,234")
        XCTAssertEqual(outputHandler.updateLoyaltyCard?.gradientStyle.light, CommonColor.appLoyaltyGradientLightBronze)
        
        XCTAssertEqual(outputHandler.updateLoyaltyCard?.gradientStyle.dark, CommonColor.appLoyaltyGradientDarkBronze)
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertEqual(viewModel.numberOfStatement, 10)
        XCTAssertTrue(outputHandler.reloadStatement)
        
        XCTAssertTrue(outputHandler.showTable)
        
        
        let service =  LoyaltyPointsServicePositiveMock()
        service.zeroStatement = true
        
        viewModel = LoyaltyPointsViewModel(router: router, userModel: getMockUser(), service: service)
        
        outputHandler = LoyaltyPointsViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.viewModelDidLoad()
        
        XCTAssertNotNil(outputHandler.updateLoyaltyCard)
        XCTAssertEqual(outputHandler.updateLoyaltyCard?.formattedPoints, "1,234")
        XCTAssertEqual(outputHandler.updateLoyaltyCard?.gradientStyle.light, CommonColor.appLoyaltyGradientLightBronze)
        
        XCTAssertEqual(outputHandler.updateLoyaltyCard?.gradientStyle.dark, CommonColor.appLoyaltyGradientDarkBronze)
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertEqual(viewModel.numberOfStatement, 0)
        XCTAssertTrue(outputHandler.reloadStatement)
        
        XCTAssertTrue(outputHandler.hideTable)
    }
    
    func testViewModelDidLoadNegative() {
        let viewModel = LoyaltyPointsViewModel(router: router, userModel: getMockUser(), service: LoyaltyPointsServiceNegativeMock())
        
        let outputHandler = LoyaltyPointsViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.viewModelDidLoad()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertNotNil(outputHandler.didShowError)
        XCTAssertEqual(outputHandler.didShowError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.didShowError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.didShowError?.errorCode, 401)
    }
    
    func testGoToAdvanceStatement() {
        let viewModel = LoyaltyPointsViewModel(router: router, userModel: getMockUser(), service: LoyaltyPointsServiceNegativeMock())
        
        viewModel.goToAdvanceStatement()
        
        XCTAssertTrue(router.didNavigateToFilter)
    }
    
    func testLoyaltyCardGradient() {
        let viewModel = LoyaltyPointsViewModel(router: router, userModel: getMockUser(), service: LoyaltyPointsServiceNegativeMock())
        
        let gradient = viewModel.loyaltyCardGradientStyle
        
        XCTAssertEqual(gradient.dark, CommonColor.appLoyaltyGradientDarkBronze)
        XCTAssertEqual(gradient.light, CommonColor.appLoyaltyGradientLightBronze)
    }
    
    func testGetStatement() {
        let viewModel = LoyaltyPointsViewModel(router: router, userModel: getMockUser(), service: LoyaltyPointsServicePositiveMock())
        
        viewModel.viewModelDidLoad()
        
        var statement = viewModel.getStatement(at: 0)
        
        XCTAssertEqual(statement.formattedPoints, "4,000")
        XCTAssertEqual(statement.infoTitle, "Award Points")
        XCTAssertFalse(statement.isEarned)
        XCTAssertEqual(statement.getCreatedData(), "18th August 2020")
    }
}

class LoyaltyPointsViewModelOutputHandler {
    
    var viewModel: LoyaltyPointsViewModel
    
    var didCallShowActivityIndicator: Bool = false
    var didCallHideActivityIndicator: Bool = false
    var didShowError: APIResponseError? = nil
    
    var reloadStatement: Bool = false
    
    var updateLoyaltyCard: LoyaltyCardViewModel?
    
    var showTable: Bool = false
    var hideTable: Bool = false
    
    func reset() {
        didCallShowActivityIndicator = false
        didCallHideActivityIndicator = false
        didShowError = nil
        
        reloadStatement = false
        updateLoyaltyCard = nil
        
        showTable = false
        hideTable = false
    }
    
    init(viewModel: LoyaltyPointsViewModel) {
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
            case .reloadStatements:
                self.reloadStatement = true
            case .updateLoyaltyCard(let viewModel):
                self.updateLoyaltyCard = viewModel
            case .showTable(let show):
                if show {
                    self.showTable = show
                } else {
                    self.hideTable = true
                }
                
            }
        }
    }
}

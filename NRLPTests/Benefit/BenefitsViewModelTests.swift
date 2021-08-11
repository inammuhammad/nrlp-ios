//
//  BenefitsViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 22/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class BenefitsViewModelTests: XCTestCase {

    var router = BenefitsRouterMock(navigationController: BaseNavigationController())
    
    func testViewWillAppearPositive() {
        let viewModel = BenefitsViewModel(router: router, service: NRLPBenefitsServicePositiveMock())
        
        let outputHandler = BenefitsViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.viewWillAppear()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertEqual(viewModel.numberOfRows, 2)
        XCTAssertTrue(outputHandler.didReloadData)
    }
    
    func testViewWillAppearNegative() {
        let viewModel = BenefitsViewModel(router: router, service: NRLPBenefitsServiceNegativeMock())
        
        let outputHandler = BenefitsViewModelOutputHandler(viewModel: viewModel)
        
        viewModel.viewWillAppear()
        
        XCTAssertTrue(outputHandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputHandler.didCallHideActivityIndicator)
        
        XCTAssertEqual(viewModel.numberOfRows, 0)
        XCTAssertNotNil(outputHandler.didShowAlert)
        XCTAssertEqual(outputHandler.didShowAlert?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.didShowAlert?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.didShowAlert?.errorCode, 401)
    }
    
    func testGetPartner() {
        let viewModel = BenefitsViewModel(router: router, service: NRLPBenefitsServicePositiveMock())
        
        viewModel.viewWillAppear()
        let partner = viewModel.getPartner(index: 0)
        
        XCTAssertEqual(partner.id, 1)
        XCTAssertEqual(partner.imageSrc, "img")
        XCTAssertEqual(partner.name, "NAdra")
    }
    
    func testDidSelectOption() {
        let viewModel = BenefitsViewModel(router: router, service: NRLPBenefitsServicePositiveMock())
        
        viewModel.viewWillAppear()
        
        viewModel.didSelectOption(index: 0)
        
        XCTAssertTrue(router.didNavigateToCategory)
    }
}

class BenefitsViewModelOutputHandler {
 
    var viewModel: BenefitsViewModel

    init(viewModel: BenefitsViewModel) {
        self.viewModel = viewModel
        setupObserver()
    }
    
    var didShowAlert: APIResponseError? = nil
    var didCallShowActivityIndicator: Bool = false
    var didCallHideActivityIndicator: Bool = false
    var didReloadData: Bool = false
    
    func reset() {
        didShowAlert = nil
        didCallShowActivityIndicator = false
        didCallHideActivityIndicator = false
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
            case .dataReload:
                self.didReloadData = true
            }
        }
    }
}

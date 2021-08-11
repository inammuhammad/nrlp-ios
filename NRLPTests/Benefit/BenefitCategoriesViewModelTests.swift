//
//  BenefitCategoriesViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 22/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class BenefitCategoriesViewModelTests: XCTestCase {

    var router = BenefitCategoriesRouterMock(navigationController: BaseNavigationController())
    
    func testViewModelDidLoadPositive() {
        let viewModel = BenefitsCategoriesViewModel(router: router, partner: getNRLPPartners(), service: NRLPBenefitsServicePositiveMock())
        let outputHandler = BenefitCategoriesOutputHandler(ViewModel: viewModel)
        
        viewModel.viewDidLoad()
        
        XCTAssertNotNil(outputHandler.partner)
        XCTAssertEqual(outputHandler.partner?.id, 1)
        XCTAssertEqual(outputHandler.partner?.name, "NAdra")
        XCTAssertEqual(outputHandler.partner?.imageSrc, "img")
        
        
        XCTAssertTrue(outputHandler.showActivityIndicator)
        XCTAssertTrue(outputHandler.hideActivityIndicator)
        
        XCTAssertTrue(outputHandler.reloadData)
        
        XCTAssertEqual(viewModel.numberOfRows, 1)
        
        XCTAssertEqual(viewModel.getCategory(index: 0).name, "urgent")
    }
    
    func testViewModelDidLoadNegative() {
        let viewModel = BenefitsCategoriesViewModel(router: router, partner: getNRLPPartners(), service: NRLPBenefitsServiceNegativeMock())
        let outputHandler = BenefitCategoriesOutputHandler(ViewModel: viewModel)
        
        viewModel.viewDidLoad()
        
        XCTAssertTrue(outputHandler.showActivityIndicator)
        XCTAssertTrue(outputHandler.hideActivityIndicator)
        
        XCTAssertFalse(outputHandler.reloadData)
        
        XCTAssertEqual(viewModel.numberOfRows, 0)
        
        XCTAssertNotNil(outputHandler.didShowError)
        XCTAssertEqual(outputHandler.didShowError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.didShowError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.didShowError?.errorCode, 401)
    }
}

class BenefitCategoriesOutputHandler {
    var didShowError: APIResponseError? = nil
    var showActivityIndicator: Bool = false
    var hideActivityIndicator: Bool = false
    var reloadData: Bool = false
    
    var partner: NRLPPartners?
    
    var viewModel: BenefitsCategoriesViewModelProtocol

    init(ViewModel: BenefitsCategoriesViewModelProtocol) {
        self.viewModel = ViewModel
        setupObserver()
    }
    
    func reset() {
        didShowError = nil
        showActivityIndicator = false
        hideActivityIndicator = false
        reloadData = false
        partner = nil
    }
    
    private func setupObserver() {
        viewModel.output = { output in
            switch output {
            case .showError(let error):
                self.didShowError = error
            case .showActivityIndicator(let show):
                if show {
                    self.showActivityIndicator = true
                } else {
                    self.hideActivityIndicator = true
                }
            case .dataReload:
                self.reloadData = true
            case .updateView(let partner):
                self.partner = partner
            }
        }
    }
}

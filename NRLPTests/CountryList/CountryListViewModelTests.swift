//
//  CountryListViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 22/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class CountryListViewModelTests: XCTestCase {

    var router = CountryListRouterMock(navigationController: BaseNavigationController())
    
    func testViewModelDidLoadPositive() {
        let viewModel = CountryListViewModel(with: CountryServicePositiveMock(), router: router, hideProgressBar: true)
        
        let outputHandler = CountryListOutputHandler(ViewModel: viewModel)
        
        viewModel.viewModelDidLoad()
        
        XCTAssertTrue(outputHandler.hideProgressBar)
        XCTAssertTrue(outputHandler.showActivityIndicator)
        XCTAssertTrue(outputHandler.hideActivityIndicator)
        
        XCTAssertEqual(viewModel.numberOfRows, 1)
        XCTAssertEqual(viewModel.getCountryName(at: 0).code, "+92")
        XCTAssertEqual(viewModel.getCountryName(at: 0).country, "Pakistan")
        XCTAssertEqual(viewModel.getCountryName(at: 0).id, 1)
        XCTAssertEqual(viewModel.getCountryName(at: 0).length, 10)
    }
    
    func testViewModelDidLoadNegative() {
        let viewModel = CountryListViewModel(with: CountryServiceNegativeMock(), router: router, hideProgressBar: true)
        
        let outputHandler = CountryListOutputHandler(ViewModel: viewModel)
        
        viewModel.viewModelDidLoad()
        
        XCTAssertTrue(outputHandler.hideProgressBar)
        XCTAssertTrue(outputHandler.showActivityIndicator)
        XCTAssertTrue(outputHandler.hideActivityIndicator)
        
        XCTAssertNotNil(outputHandler.didShowError)
        XCTAssertEqual(outputHandler.didShowError?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.didShowError?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.didShowError?.errorCode, 401)
        
        XCTAssertEqual(viewModel.numberOfRows, 0)
    }

    func testDidSelectedCountry() {
        
        let viewModel = CountryListViewModel(with: CountryServiceNegativeMock(), router: router, hideProgressBar: true)
        
        viewModel.didSelectedCountry()
        
        XCTAssertTrue(router.didPopToPreviousScreen)
    }
}

class CountryListOutputHandler {
    var didShowError: APIResponseError? = nil
    var showActivityIndicator: Bool = false
    var hideActivityIndicator: Bool = false
    var hideProgressBar: Bool = false
    var showProgressBar: Bool = false
    var reloadCountry: Bool = false
    
    var viewModel: CountryListViewModel

    init(ViewModel: CountryListViewModel) {
        self.viewModel = ViewModel
        setupObserver()
    }
    
    func reset() {
        didShowError = nil
        showActivityIndicator = false
        hideActivityIndicator = false
        hideProgressBar = false
        showProgressBar = false
        reloadCountry = false
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
            case .hideProgressBar(let hide):
                if hide {
                    self.hideProgressBar = true
                } else {
                    self.showProgressBar = true
                }
            case .reloadCountries:
                self.reloadCountry = true
            }
        }
    }
}

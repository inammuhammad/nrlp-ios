//
//  FaqVieWModelTests.swift
//  NRLPTests
//
//  Created by VenD on 23/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class FaqVieWModelTests: XCTestCase {

    func testViewModelDidLoadPositive() {
        let viewModel = FAQViewModel(with: FAQServicePositiveMock())
        
        let outputHandler = FAQViewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.viewModelDidLoad()
        
        XCTAssertTrue(outputHandler.showProgressHud)
        XCTAssertTrue(outputHandler.hideProgressHud)
        
        XCTAssertEqual(viewModel.numberOfFaqs, 12)
        
        var faq = viewModel.getFaq(for: 0)
        
        XCTAssertEqual(faq.description?.string, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Diam sit amet nisl suscipit adipiscing bibendum.")
        XCTAssertEqual(faq.faqExpandState, FAQExpandState.collapsed)
        XCTAssertEqual(faq.question, "This is question 1")
        
        XCTAssertTrue(outputHandler.didReloadData)
    }
    
    func testViewModelDidLoadNegative() {
        let viewModel = FAQViewModel(with: FAQServiceNegativeMock())
        
        let outputHandler = FAQViewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.viewModelDidLoad()
        
        XCTAssertTrue(outputHandler.showProgressHud)
        XCTAssertTrue(outputHandler.hideProgressHud)
        
        XCTAssertEqual(viewModel.numberOfFaqs, 0)
        
        XCTAssertNotNil(outputHandler.showErrorModel)
        XCTAssertTrue(outputHandler.showError)
        
        XCTAssertEqual(outputHandler.showErrorModel?.message, "No Internet Connection. Check your network settings and try again.")
        XCTAssertEqual(outputHandler.showErrorModel?.title, "Connection Failed")
        XCTAssertEqual(outputHandler.showErrorModel?.errorCode, 401)
    }
    
    func testDidTapFaq() {
        let viewModel = FAQViewModel(with: FAQServicePositiveMock())
        
        let outputHandler = FAQViewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.viewModelDidLoad()
        
        viewModel.didTapFaq(at: 0)
        
        XCTAssertEqual(viewModel.getFaq(for: 0).faqExpandState, FAQExpandState.expanded)
        
        XCTAssertTrue(outputHandler.reloadCell)
        XCTAssertEqual(outputHandler.reloadCellIndex, 0)
        
        viewModel.didTapFaq(at: 0)
        
        XCTAssertEqual(viewModel.getFaq(for: 0).faqExpandState, FAQExpandState.collapsed)
        
        XCTAssertTrue(outputHandler.reloadCell)
        XCTAssertEqual(outputHandler.reloadCellIndex, 0)
        
        viewModel.didTapFaq(at: 0)
        viewModel.didTapFaq(at: 1)
        
        XCTAssertEqual(viewModel.getFaq(for: 0).faqExpandState, FAQExpandState.collapsed)
        XCTAssertEqual(viewModel.getFaq(for: 1).faqExpandState, FAQExpandState.expanded)
        
        XCTAssertTrue(outputHandler.reloadCell)
        XCTAssertEqual(outputHandler.reloadCellIndex, 0)
    }

}

class FAQViewModelTestOutputHandler {
    
    var viewModel: FAQViewModel
    
    var showProgressHud: Bool = false
    var hideProgressHud: Bool = false
    var didReloadData: Bool = false
    
    var reloadCell: Bool = false
    var reloadCellIndex: Int?
    var showError: Bool = false
    var showErrorModel: APIResponseError?
    
    func reset() {
        showProgressHud = false
        hideProgressHud = false
        didReloadData = false
        
        reloadCell = false
        reloadCellIndex = nil
        showError = false
        showErrorModel = nil
    }
    
    init(viewModel: FAQViewModel) {
        self.viewModel = viewModel
        setupObeserver()
    }
    
    func setupObeserver() {
        viewModel.faqOutput = { output in
            
            switch output {
            
            case .showProgressHud(let show):
                if show {
                    self.showProgressHud = show
                } else {
                    self.hideProgressHud = true
                }
            case .reloadData:
                self.didReloadData = true
            case .reloadCell(let index):
                self.reloadCell = true
                self.reloadCellIndex = index
            case .showError(let error):
                self.showError = true
                self.showErrorModel = error
            }
        }
    }
    
}

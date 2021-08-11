//
//  ContactUsViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 23/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class ContactUsViewModelTests: XCTestCase {

    func testViewDidLoad() {
        let viewModel = ContactUsViewModel()
        
        let outputHandler = ContactUsiewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.viewDidLoad()
        
        XCTAssertTrue(outputHandler.didReloadData)
    }
    
    func testItems() {
        let viewModel = ContactUsViewModel()
        
        XCTAssertEqual(viewModel.numberOfRows, 3)
        
        XCTAssertEqual(viewModel.getItem(index: 0).contact, "+92111116757")
        XCTAssertEqual(viewModel.getItem(index: 0).displayContact, "+92 111 116 757")
        XCTAssertEqual(viewModel.getItem(index: 0).title, "Call Us")
        
        
        XCTAssertEqual(viewModel.getItem(index: 1).contact, "support@nrlp.com.pk")
        XCTAssertEqual(viewModel.getItem(index: 1).displayContact, "support@nrlp.com.pk")
        XCTAssertEqual(viewModel.getItem(index: 1).title, "Send us an email")
        
        
        XCTAssertEqual(viewModel.getItem(index: 2).contact, "https://www.nrlp.com.pk/")
        XCTAssertEqual(viewModel.getItem(index: 2).displayContact, "www.NRLP.com.pk")
        XCTAssertEqual(viewModel.getItem(index: 2).title, "Visit our website")
    }
    
    func testDidSelectOption() {
        let viewModel = ContactUsViewModel()
        let outputHandler = ContactUsiewModelTestOutputHandler(viewModel: viewModel)
        
        viewModel.didSelectOption(index: 0)
        XCTAssertTrue(outputHandler.showError)
        XCTAssertNotNil(outputHandler.showErrorModel)
        XCTAssertEqual(outputHandler.showErrorModel?.alertDescription, "Can\'t open Dialer")
        XCTAssertEqual(outputHandler.showErrorModel?.alertTitle, "Oh Snap!")
        
        XCTAssertFalse(outputHandler.didReloadData)
        
        Thread.sleep(forTimeInterval: 4)
        
        viewModel.didSelectOption(index: 1)
        XCTAssertTrue(outputHandler.showError)
        XCTAssertNotNil(outputHandler.showErrorModel)
        XCTAssertEqual(outputHandler.showErrorModel?.alertDescription, "Can\'t open Email client")
        XCTAssertEqual(outputHandler.showErrorModel?.alertTitle, "Oh Snap!")
        
        XCTAssertFalse(outputHandler.didReloadData)
        
        outputHandler.reset()
        
        viewModel.didSelectOption(index: 2)
        XCTAssertFalse(outputHandler.showError)
        XCTAssertNil(outputHandler.showErrorModel)
        
        XCTAssertFalse(outputHandler.didReloadData)
        
        outputHandler.reset()
    }
}

class ContactUsiewModelTestOutputHandler {
    
    var viewModel: ContactUsViewModel
    
    var showProgressHud: Bool = false
    var hideProgressHud: Bool = false
    var didReloadData: Bool = false
    
    var reloadCell: Bool = false
    var reloadCellIndex: Int?
    var showError: Bool = false
    var showErrorModel: AlertViewModel?
    
    func reset() {
        showProgressHud = false
        hideProgressHud = false
        didReloadData = false
        
        reloadCell = false
        reloadCellIndex = nil
        showError = false
        showErrorModel = nil
    }
    
    init(viewModel: ContactUsViewModel) {
        self.viewModel = viewModel
        setupObeserver()
    }
    
    func setupObeserver() {
        viewModel.output = { output in
            
            switch output {
            
            case .showActivityIndicator(let show):
                if show {
                    self.showProgressHud = show
                } else {
                    self.hideProgressHud = true
                }
            case .dataReload:
                self.didReloadData = true
            case .showError(let error):
                self.showError = true
                self.showErrorModel = error
            }
        }
    }
    
}

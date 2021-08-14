//
//  SideMenuViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 21/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class SideMenuViewModelTests: XCTestCase {
    
    func testNumberOfItems() {
        
        let viewModel = SideMenuViewModel(with: getMockUser())
        
        XCTAssertEqual(viewModel.numberOfItems, 6)
    }
    
    func testGetItemAtIndex() {
        
        let viewModel = SideMenuViewModel(with: getMockUser())
        
        XCTAssertEqual(viewModel.getItem(at: 1), SideMenuItem.changePassword)
    }
    
    func testDidTapItem() {
        
        var viewModel: SideMenuViewModelProtocol = SideMenuViewModel(with: getMockUser())
        let outputHander = SideMenuViewModelOutputHandler(ViewModel: &viewModel)
        
        viewModel.didTapItem(at: 1)
        XCTAssertTrue(outputHander.navigateToSection)
        XCTAssertNotNil(outputHander.navigatedSection)
        XCTAssertEqual(outputHander.navigatedSection, viewModel.getItem(at: 1))
    }
    
    func testViewModelDidLoad() {
        
        var viewModel: SideMenuViewModelProtocol = SideMenuViewModel(with: getMockUser())
        let outputHander = SideMenuViewModelOutputHandler(ViewModel: &viewModel)
        
        viewModel.viewModelDidLoad()
        
        XCTAssertTrue(outputHander.updateVersionNumber)
        XCTAssertNotNil(outputHander.versionNumber)
        XCTAssertEqual(outputHander.versionNumber, "Version 3.0-36")
    }
}

class SideMenuViewModelOutputHandler {
    
    var navigateToSection: Bool = false
    var updateVersionNumber: Bool = false
    
    var navigatedSection: SideMenuItem?
    var versionNumber: String?
    
    init(ViewModel: inout SideMenuViewModelProtocol) {
        setupObserver(ViewModel: &ViewModel)
    }
    
    func reset() {
        navigateToSection = false
        updateVersionNumber = false
        navigatedSection = nil
        versionNumber = nil
    }
    
    private func setupObserver(ViewModel: inout SideMenuViewModelProtocol) {
        ViewModel.output = { output in
            switch output {
            case .navigateToSection(let item):
                self.navigateToSection = true
                self.navigatedSection = item
            case .updateVersionNumber(let version):
                self.updateVersionNumber = true
                self.versionNumber = version
            }
        }
    }
}


//
//  LanguageViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 22/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class LanguageViewModelTests: XCTestCase {

    var router = LanguageRouterMock(navigationController: BaseNavigationController())
    
    func testViewModelDidLoad() {
        
        NRLPUserDefaults.shared.removeSelectedLanguage()
        
        var viewModel = LanguageViewModel(router: router, user: getMockUser())
        
        let outputHandler = LanguageViewModelOutputHandler(ViewModel: viewModel)
        
        viewModel.viewModelDidLoad()
        
        XCTAssertEqual(outputHandler.currentSelectedLanguageIndex, 0)
        
        NRLPUserDefaults.shared.set(selectedLanguage: .english)
        
        viewModel = LanguageViewModel(router: router, user: getMockUser())
        
        viewModel.viewModelDidLoad()
        
        XCTAssertEqual(outputHandler.currentSelectedLanguageIndex, 0)
        
        NRLPUserDefaults.shared.set(selectedLanguage: .urdu)
        
        viewModel.viewModelDidLoad()
        
        XCTAssertEqual(outputHandler.currentSelectedLanguageIndex, 0)
    }
    
    override func tearDown() {
        NRLPUserDefaults.shared.set(selectedLanguage: .english)
    }
    
    func testConfirmLanguageUpdate() {
        
        let viewModel = LanguageViewModel(router: router, user: getMockUser())
        
        let outputHandler = LanguageViewModelOutputHandler(ViewModel: viewModel)
        
        NRLPUserDefaults.shared
            .removeSelectedLanguage()
        
        XCTAssertNil(NRLPUserDefaults.shared.getSelectedLanguage())
        
        viewModel.selectedLanguage = "en"
        
        router.setWorkingAsHome = true
        viewModel.confirmLanguageUpdate()
        
        XCTAssertNotNil(NRLPUserDefaults.shared.getSelectedLanguage())
        
        XCTAssertTrue(router.isRootNavigationItemFetched)
        XCTAssertTrue(router.isNavigtedToHome)
        
        router.setWorkingAsHome = false
        viewModel.confirmLanguageUpdate()
        
        XCTAssertTrue(router.isNavigatedToLogin)
    }
    
    func testDidTapSaveButton() {
        let viewModel = LanguageViewModel(router: router, user: getMockUser())
        
        let outputHandler = LanguageViewModelOutputHandler(ViewModel: viewModel)
        
        NRLPUserDefaults.shared.removeSelectedLanguage()
        viewModel.didTapSaveButton()
        
        NRLPUserDefaults.shared.set(selectedLanguage: .english)
        
        viewModel.didTapSaveButton()
        
        XCTAssertNotNil(outputHandler.alertViewModel)
        XCTAssertEqual(outputHandler.alertViewModel?.alertDescription, "Application has monitored a change in language, continuing with it will restart the application. Do you want to continue?")
    }
}


class LanguageViewModelOutputHandler {
    
    var nextButtonStateEnabled: Bool = false
    var nextButtonStateDisabled: Bool = false
    var currentSelectedLanguageIndex: Int = -1
    var alertViewModel: AlertViewModel? = nil
    
    var viewModel: LanguageViewModelProtocol

    init(ViewModel: LanguageViewModelProtocol) {
        self.viewModel = ViewModel
        setupObserver()
    }
    
    func reset() {
        nextButtonStateEnabled = false
        nextButtonStateDisabled = false
        currentSelectedLanguageIndex = -1
    
        alertViewModel = nil
    }
    
    private func setupObserver() {
        viewModel.output = { output in
            switch output {
            case .nextButtonState(let enabled):
                if enabled {
                    self.nextButtonStateEnabled = true
                } else {
                    self.nextButtonStateDisabled = true
                }
                
            case .setCurrentLanguageSelected(let index):
                self.currentSelectedLanguageIndex = index
            case .showAlert(let alert):
                self.alertViewModel = alert
                
            }
        }
    }
}


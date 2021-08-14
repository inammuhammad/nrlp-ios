//
//  TransferPointsViewModelTests.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 20/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class TransferPointsViewModelTests: XCTestCase {
    
    var transferPointsViewModel: TransferPointsViewModelProtocol!
    var router: TransferPointsRouterMock = TransferPointsRouterMock()
    private var service: ManageBeneficiaryServiceProtocol!
    private var loyaltyPointService: LoyaltyPointsServiceProtocol!
    private var commonBeneficiary = BeneficiaryModel(alias: "Aqib", beneficiaryId: 1234, isActive: 1, mobileNo: "+923215878488", nicNicop: 234323432323, createdAt: "", updatedAt: "", isDeleted: 0)
    
    private var commonUserModel: UserModel!
    
    override func setUp() {
        
        commonUserModel = getMockUser()
        
        transferPointsViewModel = TransferPointsViewModel(with: router, user: commonUserModel, service: ManageBeneficiaryServicePositiveMock(), loyaltyPointService: LoyaltyPointsServicePositiveMock())
        
    }
    
    func testTransferPointsButtonPressedPositive() {
        
        let transferPointsViewModelOutputhandler = TransferPointsViewModelOutputHandler(transferPointsViewModel: transferPointsViewModel)
        transferPointsViewModel.transferPoints = "1000"
        transferPointsViewModel.beneficiary = commonBeneficiary
        
        XCTAssertTrue(transferPointsViewModelOutputhandler.didSetNextButtonStateEnabled)
        transferPointsViewModel.didTapTransferButton()
        XCTAssertTrue(transferPointsViewModelOutputhandler.didShowAlert)
        XCTAssertTrue(transferPointsViewModelOutputhandler.didCallShowActivityIndicator)
        XCTAssertTrue(transferPointsViewModelOutputhandler.didCallHideActivityIndicator)
        XCTAssertTrue(router.isNavigatedToSuccess)
    }
    
    func testTransferPointsButtonPressedNegative() {
        
        let transferPointsViewModelOutputhandler = TransferPointsViewModelOutputHandler(transferPointsViewModel: transferPointsViewModel)
        transferPointsViewModel.transferPoints = "2000"
        transferPointsViewModel.beneficiary = commonBeneficiary
        
        transferPointsViewModel.didTapTransferButton()
        XCTAssertTrue(transferPointsViewModelOutputhandler.didShowAlert)
        XCTAssertFalse(router.isNavigatedToSuccess)
    }
    
    func testTransferAmount() {
        
        let transferPointsViewModelOutputhandler = TransferPointsViewModelOutputHandler(transferPointsViewModel: transferPointsViewModel)
        transferPointsViewModel.transferPoints = "-100"
        transferPointsViewModel.beneficiary = commonBeneficiary
        
        transferPointsViewModel.didTapTransferButton()
        XCTAssertTrue(transferPointsViewModelOutputhandler.didSetNextButtonStateDisabled)
        XCTAssertFalse(transferPointsViewModelOutputhandler.didSetNextButtonStateEnabled)
        XCTAssertFalse(router.isNavigatedToSuccess)
        
        transferPointsViewModelOutputhandler.reset()
        
        transferPointsViewModel.transferPoints = "ABC"
        transferPointsViewModel.beneficiary = commonBeneficiary
        
        XCTAssertTrue(transferPointsViewModelOutputhandler.didSetNextButtonStateDisabled)
        XCTAssertFalse(transferPointsViewModelOutputhandler.didSetNextButtonStateEnabled)
        XCTAssertFalse(router.isNavigatedToSuccess)
        
        transferPointsViewModelOutputhandler.reset()
    }
    
    func testViewModelWillAppear() {
        
        
        var viewModel = TransferPointsViewModel(with: router, user: getMockUser(), service: ManageBeneficiaryServicePositiveMock(), loyaltyPointService: LoyaltyPointsServicePositiveMock())
        
        var outputhandler = TransferPointsViewModelOutputHandler(transferPointsViewModel: viewModel)
        
        
        viewModel.viewModelWillAppear()
        
        XCTAssertTrue(outputhandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputhandler.didCallHideActivityIndicator)
        XCTAssertTrue(outputhandler.didReloadBeneficiary)
        
        XCTAssertNotNil(viewModel.beneficiaryItems)
        XCTAssertEqual(viewModel.beneficiaryItems.count, 1)
        
        viewModel = TransferPointsViewModel(with: router, user: commonUserModel, service: ManageBeneficiaryServiceNegativeMock(), loyaltyPointService: LoyaltyPointsServicePositiveMock())
        
        viewModel.viewModelWillAppear()
        
        outputhandler = TransferPointsViewModelOutputHandler(transferPointsViewModel: viewModel)
        viewModel.viewModelWillAppear()
        
        XCTAssertTrue(outputhandler.didCallShowActivityIndicator)
        XCTAssertTrue(outputhandler.didCallHideActivityIndicator)
        XCTAssertFalse(outputhandler.didReloadBeneficiary)
        
        XCTAssertNotNil(viewModel.beneficiaryItems)
        XCTAssertEqual(viewModel.beneficiaryItems.count, 0)
    }
    
    func testDidSelectBeneficiaryItem() {
        
        let outputhandler = TransferPointsViewModelOutputHandler(transferPointsViewModel: transferPointsViewModel)
        
        transferPointsViewModel.didSelect(beneficiaryItem: BeneficiaryPickerItemModel(title: "Ahmed", key: "ahmed", beneficiary: getMockBeneficiary()))
        
        XCTAssertEqual(transferPointsViewModel.beneficiary?.alias, getMockBeneficiary().alias)
        XCTAssertEqual(transferPointsViewModel.beneficiary?.beneficiaryId, getMockBeneficiary().beneficiaryId)
        XCTAssertEqual(transferPointsViewModel.beneficiary?.formattedCNIC, getMockBeneficiary().formattedCNIC)
        XCTAssertEqual(transferPointsViewModel.beneficiary?.mobileNo, getMockBeneficiary().mobileNo)
        XCTAssertEqual(transferPointsViewModel.beneficiary?.nicNicop, getMockBeneficiary().nicNicop)
        
        XCTAssertTrue(outputhandler.didUpdateBeneficiary)
        
        var beneficiary = getMockBeneficiary()
        beneficiary.alias = nil
        
        transferPointsViewModel.didSelect(beneficiaryItem: BeneficiaryPickerItemModel(title: "Ahmed", key: "ahmed", beneficiary: beneficiary))
        
        XCTAssertEqual(outputhandler.updateBeneficiaryAlias, "Name".localized)
        XCTAssertEqual(transferPointsViewModel.beneficiary?.beneficiaryId, getMockBeneficiary().beneficiaryId)
        XCTAssertEqual(transferPointsViewModel.beneficiary?.formattedCNIC, getMockBeneficiary().formattedCNIC)
        XCTAssertEqual(transferPointsViewModel.beneficiary?.mobileNo, getMockBeneficiary().mobileNo)
        XCTAssertEqual(transferPointsViewModel.beneficiary?.nicNicop, getMockBeneficiary().nicNicop)
        
        XCTAssertTrue(outputhandler.didUpdateBeneficiary)
    }
    
    func testItemPicker() {
        
        transferPointsViewModel.viewModelWillAppear()
        
        var beneficiary = getMockBeneficiary()
        
        transferPointsViewModel.didSelect(beneficiaryItem: BeneficiaryPickerItemModel(title: "Ahmed", key: "ahmed", beneficiary: beneficiary))
        
        let picker = transferPointsViewModel.beneficiaryPickerViewModel
        
        XCTAssertEqual(picker.data.count, 1)
        XCTAssertEqual(picker.data.first?.key, "1234")
        XCTAssertEqual(picker.data.first?.title, "Test")
    }
    
    func testPointTransfer() {
        
        var viewModel = TransferPointsViewModel(with: router, user: getMockUser(), service: ManageBeneficiaryServicePositiveMock(), loyaltyPointService: LoyaltyPointsServicePositiveMock())
        
        var transferPointsViewModelOutputhandler = TransferPointsViewModelOutputHandler(transferPointsViewModel: viewModel)
        viewModel.transferPoints = "1000"
        viewModel.beneficiary = commonBeneficiary
        
        XCTAssertTrue(transferPointsViewModelOutputhandler.didSetNextButtonStateEnabled)
        viewModel.didTapTransferButton()
        
        XCTAssertTrue(router.isNavigatedToSuccess)
        
        
        viewModel = TransferPointsViewModel(with: router, user: getMockUser(), service: ManageBeneficiaryServicePositiveMock(), loyaltyPointService: LoyaltyPointsServiceNegativeMock())
        
        viewModel.beneficiary = getMockBeneficiary()
        
        transferPointsViewModelOutputhandler = TransferPointsViewModelOutputHandler(transferPointsViewModel: viewModel)
        viewModel.transferPoints = "1000"
        viewModel.beneficiary = commonBeneficiary
        
        XCTAssertTrue(transferPointsViewModelOutputhandler.didSetNextButtonStateEnabled)
        viewModel.didTapTransferButton()
        XCTAssertNotNil(transferPointsViewModelOutputhandler.didShowError)
        XCTAssertEqual(transferPointsViewModelOutputhandler.didShowError, "No Internet Connection. Check your network settings and try again.")
    }
    
}

class TransferPointsViewModelOutputHandler {
    
    var transferPointsViewModel: TransferPointsViewModelProtocol
    
    var didCallShowActivityIndicator: Bool = false
    var didCallHideActivityIndicator: Bool = false
    var didShowError: String? = nil
    var didSetNextButtonStateEnabled: Bool = false
    var didSetNextButtonStateDisabled: Bool = false
    var didSetTransferPointsTextFieldError: String? = nil
    var didSetBeneficiaryTextFieldError: String? = nil
    var didShowNoBeneficiary: Bool = true
    var didUpdateBeneficiary: Bool = false
    var updateBeneficiaryAlias: String?
    var didReloadBeneficiary: Bool = false
    var didUpdateLoyaltyPoints: Bool = false
    var didShowAlert: Bool = false
    
    init(transferPointsViewModel: TransferPointsViewModelProtocol) {
        self.transferPointsViewModel = transferPointsViewModel
        setupObserver()
    }
    
    func reset() {
        didCallShowActivityIndicator = false
        didCallHideActivityIndicator = false
        didSetNextButtonStateEnabled = false
        didSetNextButtonStateDisabled = false
        didShowNoBeneficiary = true
        didUpdateBeneficiary = false
        didReloadBeneficiary = false
        updateBeneficiaryAlias = nil
    }
    
    private func setupObserver() {
        transferPointsViewModel.output = { output in
            switch output {
            case .showActivityIndicator(let show):
                if show {
                    self.didCallShowActivityIndicator = true
                } else {
                    self.didCallHideActivityIndicator = true
                }
            case .showError(let error):
                self.didShowError = error.message
            case .nextButtonState(let enableState):
                if enableState {
                    self.didSetNextButtonStateEnabled = true
                } else {
                    self.didSetNextButtonStateDisabled = true
                }
            case .updateBeneficiary(let alias):
                self.didUpdateBeneficiary = true
                self.updateBeneficiaryAlias = alias
            case .transferPointsTextField(let errorState, let error):
                self.didSetTransferPointsTextFieldError = error
            case .beneficiaryTextField(let errorState, let error):
                self.didSetBeneficiaryTextFieldError = error
            case .reloadBeneficiaries:
                self.didReloadBeneficiary = true
            case .updateLoyaltyCard(let viewModel):
                self.didUpdateLoyaltyPoints = true
            case .showNoBeneficiary(let show):
                self.didShowNoBeneficiary = show
            case .showAlert(let alert):
                self.didShowAlert = true
                alert.primaryButton.buttonAction?()
            }
            
        }
    }
}

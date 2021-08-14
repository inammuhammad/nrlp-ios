//
//  UpdateProfileViewModelTests.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 26/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class UpdateProfileViewModelTests: XCTestCase {

    private var profileViewModel: ProfileViewModelProtocol!
    private var router = UpdateProfileRouterMock()
    private var service: UserProfileServiceProtocol!

    private var commonCountry = Country(code: "+92", country: "Pakistan", length: 10, id: 1, createdAt: "", updatedAt: "", isActive: 1, isDeleted: 0)
    
    override func setUp() {
        profileViewModel = ProfileViewModel(router: router, userProfileService: UserProfileServicePositiveMock())
        profileViewModel.viewDidLoad()
    }
    
    func testUpdateProfilePositive() {
        let updateProfileViewModelOutputhandler = UpdateProfileViewModelOutputHandler(updateProfileViewModel: profileViewModel)
        
        profileViewModel.editButtonPressed()
        profileViewModel.email = "abc@abc.com"
        profileViewModel.country = commonCountry
        profileViewModel.mobileNumber = "3335353533"
        
        XCTAssertTrue(updateProfileViewModelOutputhandler.didSetNextButtonStateEnabled)
        profileViewModel.saveButtonPressed()
        XCTAssertTrue(updateProfileViewModelOutputhandler.didShowAlert)
        XCTAssertTrue(updateProfileViewModelOutputhandler.didCallShowActivityIndicator)
        XCTAssertTrue(updateProfileViewModelOutputhandler.didCallHideActivityIndicator)
        XCTAssertTrue(router.isNavigatedToOTPScreen)
    }
    
    func testUpdateProfileNegative() {
        let updateProfileViewModelOutputhandler = UpdateProfileViewModelOutputHandler(updateProfileViewModel: profileViewModel)
        
        profileViewModel.editButtonPressed()
        profileViewModel.email = "abc"
        profileViewModel.country = commonCountry
        profileViewModel.mobileNumber = "3335353533"
        
        XCTAssertTrue(updateProfileViewModelOutputhandler.didSetNextButtonStateEnabled)
        profileViewModel.saveButtonPressed()
        XCTAssertNotNil(updateProfileViewModelOutputhandler.didSetEmailLabelError)
        XCTAssertFalse(updateProfileViewModelOutputhandler.didCallShowActivityIndicator)
        XCTAssertFalse(router.isNavigatedToOTPScreen)
        
        updateProfileViewModelOutputhandler.reset()
        
        profileViewModel.email = "abc@abc.com"
        profileViewModel.country = commonCountry
        profileViewModel.mobileNumber = "333"
        
        XCTAssertTrue(updateProfileViewModelOutputhandler.didSetNextButtonStateEnabled)
        profileViewModel.saveButtonPressed()
        XCTAssertNotNil(updateProfileViewModelOutputhandler.didSetMobileLabelError)
        XCTAssertFalse(updateProfileViewModelOutputhandler.didCallShowActivityIndicator)
        XCTAssertFalse(router.isNavigatedToOTPScreen)
        
        updateProfileViewModelOutputhandler.reset()
    }
    
    func testEmail() {
        let updateProfileViewModelOutputhandler = UpdateProfileViewModelOutputHandler(updateProfileViewModel: profileViewModel)
        
        profileViewModel.editButtonPressed()
        profileViewModel.country = commonCountry
        
        profileViewModel.mobileNumber = "3335353533"
        
        profileViewModel.email = "abc@abc.com"
        XCTAssertTrue(updateProfileViewModelOutputhandler.didSetNextButtonStateEnabled)
        XCTAssertNil(updateProfileViewModelOutputhandler.didSetEmailLabelError)
        
        updateProfileViewModelOutputhandler.reset()
        
        profileViewModel.email = "abc@"
        XCTAssertTrue(updateProfileViewModelOutputhandler.didSetNextButtonStateEnabled)
        profileViewModel.saveButtonPressed()
        XCTAssertNotNil(updateProfileViewModelOutputhandler.didSetEmailLabelError)
        
        updateProfileViewModelOutputhandler.reset()
        
        profileViewModel.email = "12345"
        XCTAssertTrue(updateProfileViewModelOutputhandler.didSetNextButtonStateEnabled)
        profileViewModel.saveButtonPressed()
        XCTAssertNotNil(updateProfileViewModelOutputhandler.didSetEmailLabelError)
    }
    
    func testMobile() {
        let updateProfileViewModelOutputhandler = UpdateProfileViewModelOutputHandler(updateProfileViewModel: profileViewModel)
        
        profileViewModel.editButtonPressed()
        profileViewModel.country = commonCountry
        
        profileViewModel.mobileNumber = "3335353533"
        XCTAssertTrue(updateProfileViewModelOutputhandler.didSetNextButtonStateEnabled)
        profileViewModel.saveButtonPressed()
        XCTAssertNil(updateProfileViewModelOutputhandler.didSetMobileLabelError)

        updateProfileViewModelOutputhandler.reset()
        
        profileViewModel.mobileNumber = "33353535353"
        XCTAssertTrue(updateProfileViewModelOutputhandler.didSetNextButtonStateEnabled)
        profileViewModel.saveButtonPressed()
        XCTAssertNotNil(updateProfileViewModelOutputhandler.didSetMobileLabelError)

        updateProfileViewModelOutputhandler.reset()

        profileViewModel.mobileNumber = "3335353"
        XCTAssertTrue(updateProfileViewModelOutputhandler.didSetNextButtonStateEnabled)
        profileViewModel.saveButtonPressed()
        XCTAssertNotNil(updateProfileViewModelOutputhandler.didSetMobileLabelError)

        updateProfileViewModelOutputhandler.reset()

        profileViewModel.mobileNumber = "Abc"
        XCTAssertTrue(updateProfileViewModelOutputhandler.didSetNextButtonStateEnabled)
        profileViewModel.saveButtonPressed()
        XCTAssertNotNil(updateProfileViewModelOutputhandler.didSetMobileLabelError)
    }
    
    func testUserName() {
        let mockUser = getMockUser()
        XCTAssertEqual(profileViewModel.name, mockUser.fullName)
        XCTAssertEqual(profileViewModel.cnic, "\(mockUser.cnicNicop)")
    }
}

class UpdateProfileViewModelOutputHandler {
    
    var updateProfileViewModel: ProfileViewModelProtocol
    
    var didSetNextButtonStateEnabled: Bool = false
    var didSetNextButtonStateDisabled: Bool = false
    var didUpdateCountry: Bool = false
    var didUpdateMobileCode: Bool = false
    var didUpdateMobilePlaceholder: Bool = false
    var didSetMobileLabelError: String? = nil
    var didSetEmailLabelError: String? = nil
    var didShowAlert: Bool = false
    var didCallShowActivityIndicator: Bool = false
    var didCallHideActivityIndicator: Bool = false
    var didEnableEditing = false
    var didResetEditing: Bool = false
    var didShowError: Error? = nil
       
    init(updateProfileViewModel: ProfileViewModelProtocol) {
        self.updateProfileViewModel = updateProfileViewModel
        setupObserver()
    }
    
    func reset() {
        didSetNextButtonStateEnabled = false
        didSetNextButtonStateDisabled = false
        didUpdateCountry = false
        didUpdateMobileCode = false
        didUpdateMobilePlaceholder = false
        didSetMobileLabelError  = nil
        didSetEmailLabelError  = nil
        didShowAlert = false
        didCallShowActivityIndicator = false
        didCallHideActivityIndicator = false
        didEnableEditing = false
        didResetEditing = false
        didShowError  = nil
    }
    
    private func setupObserver() {
        updateProfileViewModel.output = { output in
            switch output {
            case .updateCountry:
                self.didUpdateCountry = true
            case .updateMobileCode:
                self.didUpdateMobileCode = true
            case .updateMobilePlaceholder:
                self.didUpdateMobilePlaceholder = true
            case .nextButtonState(let enableState):
                if enableState {
                    self.didSetNextButtonStateEnabled = true
                } else {
                    self.didSetNextButtonStateDisabled = true
                }
            case .mobileNumberTextField(let errorState, let error):
                self.didSetMobileLabelError = error
            case .emailTextField(let errorState, let error):
                self.didSetEmailLabelError = error
            case .showAlert(let alert):
                alert.primaryButton.buttonAction?()
                self.didShowAlert = true
            case .editingEnabled:
                self.didEnableEditing = true
            case .editingReset:
                self.didResetEditing = true
            case .showActivityIndicator(let show):
                if show {
                    self.didCallShowActivityIndicator = true
                } else {
                    self.didCallHideActivityIndicator = true
                }
            case .showError(let error):
                self.didShowError = error
            default:
                print ("default state")
            }
        }
    }
    
}

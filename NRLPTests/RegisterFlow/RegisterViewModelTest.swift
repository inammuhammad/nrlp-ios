//
//  RegisterViewModelTest.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 28/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class RegisterViewModelTest: XCTestCase {

    var output: RegistrationViewModelOutput?
    private var router = RegistrationRouterMock()
    private var viewModel: RegistrationViewModelProtocol!
    
    private var commonCountry = Country(code: "+92", country: "Pakistan", length: 10, id: 1, createdAt: "", updatedAt: "", isActive: 1, isDeleted: 0)
    
    override func setUp() {
        viewModel = RegistrationViewModel(router: router)
    }
    
    enum Constants: String {
        case testPass = "Test@1234"
        case email = "abc@abc.com"
        case name = "Muhammad Ali"
    }
    
    func testRegistrationPossitive() {
        let outputHandler = RegistrationViewModelOutputHandler(registrationViewModel: viewModel)
        
        // Beneficiary
        viewModel.name = Constants.name.rawValue
        viewModel.cnic = "1234512345671"
        (viewModel as? RegistrationViewModel)?.country = commonCountry
        viewModel.mobileNumber = "3215878488"
        viewModel.email = Constants.email.rawValue
        viewModel.paassword = Constants.testPass.rawValue
        viewModel.rePaassword = Constants.testPass.rawValue
        (viewModel as? RegistrationViewModel)?.accountType = .beneficiary
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
        viewModel.nextButtonPressed()
        XCTAssertNil(outputHandler.didSetNameLabelError)
        XCTAssertNil(outputHandler.didSetCNICLabelError)
        XCTAssertNil(outputHandler.didSetCountryLabelError)
        XCTAssertNil(outputHandler.didSetMobileNumberLabelError)
        XCTAssertNil(outputHandler.didSetEmailLabelError)
        XCTAssertNil(outputHandler.didSetPassLabelError)
        XCTAssertNil(outputHandler.didSetRetypePassLabelError)
        XCTAssertNil(outputHandler.didSetAccountTypeLabelError)
        XCTAssertTrue(router.isNavigatedToBeneficiaryVerification)
        XCTAssertFalse(router.isNavigatedToRemitterVerification)
        outputHandler.reset()
        router.reset()
        
        // Remitter
        viewModel.name = Constants.name.rawValue
        viewModel.cnic = "1234512345671"
        (viewModel as? RegistrationViewModel)?.country = commonCountry
        viewModel.mobileNumber = "3215878488"
        viewModel.email = Constants.email.rawValue
        viewModel.paassword = Constants.testPass.rawValue
        viewModel.rePaassword = Constants.testPass.rawValue
        (viewModel as? RegistrationViewModel)?.accountType = .remitter
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
        viewModel.nextButtonPressed()
        XCTAssertNil(outputHandler.didSetNameLabelError)
        XCTAssertNil(outputHandler.didSetCNICLabelError)
        XCTAssertNil(outputHandler.didSetCountryLabelError)
        XCTAssertNil(outputHandler.didSetMobileNumberLabelError)
        XCTAssertNil(outputHandler.didSetEmailLabelError)
        XCTAssertNil(outputHandler.didSetPassLabelError)
        XCTAssertNil(outputHandler.didSetRetypePassLabelError)
        XCTAssertNil(outputHandler.didSetAccountTypeLabelError)
        XCTAssertTrue(router.isNavigatedToRemitterVerification)
        XCTAssertFalse(router.isNavigatedToBeneficiaryVerification)
        outputHandler.reset()
        router.reset()
    }
    
    func testRegistrationNegative() {
        let outputHandler = RegistrationViewModelOutputHandler(registrationViewModel: viewModel)
        
        
//        Wrong Name
        viewModel.name = "123"
        viewModel.cnic = "1234512345671"
        (viewModel as? RegistrationViewModel)?.country = commonCountry
        viewModel.mobileNumber = "3215878488"
        viewModel.email = Constants.email.rawValue
        viewModel.paassword = Constants.testPass.rawValue
        viewModel.rePaassword = Constants.testPass.rawValue
        (viewModel as? RegistrationViewModel)?.accountType = .beneficiary
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
        viewModel.nextButtonPressed()
        XCTAssertNotNil(outputHandler.didSetNameLabelError)
        XCTAssertNil(outputHandler.didSetCNICLabelError)
        XCTAssertNil(outputHandler.didSetCountryLabelError)
        XCTAssertNil(outputHandler.didSetMobileNumberLabelError)
        XCTAssertNil(outputHandler.didSetEmailLabelError)
        XCTAssertNil(outputHandler.didSetPassLabelError)
        XCTAssertNil(outputHandler.didSetRetypePassLabelError)
        XCTAssertNil(outputHandler.didSetAccountTypeLabelError)
        outputHandler.reset()
        router.reset()
        
//      Wrong CNIC
        viewModel.name = Constants.name.rawValue
        viewModel.cnic = "ABC"
        (viewModel as? RegistrationViewModel)?.country = commonCountry
        viewModel.mobileNumber = "3215878488"
        viewModel.email = Constants.email.rawValue
        viewModel.paassword = Constants.testPass.rawValue
        viewModel.rePaassword = Constants.testPass.rawValue
        (viewModel as? RegistrationViewModel)?.accountType = .beneficiary
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
        viewModel.nextButtonPressed()
        XCTAssertNil(outputHandler.didSetNameLabelError)
        XCTAssertNotNil(outputHandler.didSetCNICLabelError)
        XCTAssertNil(outputHandler.didSetCountryLabelError)
        XCTAssertNil(outputHandler.didSetMobileNumberLabelError)
        XCTAssertNil(outputHandler.didSetEmailLabelError)
        XCTAssertNil(outputHandler.didSetPassLabelError)
        XCTAssertNil(outputHandler.didSetRetypePassLabelError)
        XCTAssertNil(outputHandler.didSetAccountTypeLabelError)
        outputHandler.reset()
        router.reset()

//      Wrong Mobile Length
        viewModel.name = Constants.name.rawValue
        viewModel.cnic = "1234512345671"
        (viewModel as? RegistrationViewModel)?.country = commonCountry
        viewModel.mobileNumber = "123456789011" // required are 10
        viewModel.email = Constants.email.rawValue
        viewModel.paassword = Constants.testPass.rawValue
        viewModel.rePaassword = Constants.testPass.rawValue
        (viewModel as? RegistrationViewModel)?.accountType = .beneficiary
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
        viewModel.nextButtonPressed()
        XCTAssertNil(outputHandler.didSetNameLabelError)
        XCTAssertNil(outputHandler.didSetCNICLabelError)
        XCTAssertNil(outputHandler.didSetCountryLabelError)
        XCTAssertNotNil(outputHandler.didSetMobileNumberLabelError)
        XCTAssertNil(outputHandler.didSetEmailLabelError)
        XCTAssertNil(outputHandler.didSetPassLabelError)
        XCTAssertNil(outputHandler.didSetRetypePassLabelError)
        XCTAssertNil(outputHandler.didSetAccountTypeLabelError)
        outputHandler.reset()
        router.reset()
        

//      Wrong Mobile Format
        viewModel.name = Constants.name.rawValue
        viewModel.cnic = "1234512345671"
        (viewModel as? RegistrationViewModel)?.country = commonCountry
        viewModel.mobileNumber = "ABCABCABCA"
        viewModel.email = Constants.email.rawValue
        viewModel.paassword = Constants.testPass.rawValue
        viewModel.rePaassword = Constants.testPass.rawValue
        (viewModel as? RegistrationViewModel)?.accountType = .beneficiary
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
        viewModel.nextButtonPressed()
        XCTAssertNil(outputHandler.didSetNameLabelError)
        XCTAssertNil(outputHandler.didSetCNICLabelError)
        XCTAssertNil(outputHandler.didSetCountryLabelError)
        XCTAssertNotNil(outputHandler.didSetMobileNumberLabelError)
        XCTAssertNil(outputHandler.didSetEmailLabelError)
        XCTAssertNil(outputHandler.didSetPassLabelError)
        XCTAssertNil(outputHandler.didSetRetypePassLabelError)
        XCTAssertNil(outputHandler.didSetAccountTypeLabelError)
        outputHandler.reset()
        router.reset()
        

//      Wrong Email
        viewModel.name = Constants.name.rawValue
        viewModel.cnic = "1234512345671"
        (viewModel as? RegistrationViewModel)?.country = commonCountry
        viewModel.mobileNumber = "3215878488"
        viewModel.email = "abc@"
        viewModel.paassword = Constants.testPass.rawValue
        viewModel.rePaassword = Constants.testPass.rawValue
        (viewModel as? RegistrationViewModel)?.accountType = .beneficiary
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
        viewModel.nextButtonPressed()
        XCTAssertNil(outputHandler.didSetNameLabelError)
        XCTAssertNil(outputHandler.didSetCNICLabelError)
        XCTAssertNil(outputHandler.didSetCountryLabelError)
        XCTAssertNil(outputHandler.didSetMobileNumberLabelError)
        XCTAssertNotNil(outputHandler.didSetEmailLabelError)
        XCTAssertNil(outputHandler.didSetPassLabelError)
        XCTAssertNil(outputHandler.didSetRetypePassLabelError)
        XCTAssertNil(outputHandler.didSetAccountTypeLabelError)
        outputHandler.reset()
        router.reset()
        

//      Wrong Password
        viewModel.name = Constants.name.rawValue
        viewModel.cnic = "1234512345671"
        (viewModel as? RegistrationViewModel)?.country = commonCountry
        viewModel.mobileNumber = "3215878488"
        viewModel.email = Constants.email.rawValue
        viewModel.paassword = "Test@"
        viewModel.rePaassword = "Test@"
        (viewModel as? RegistrationViewModel)?.accountType = .beneficiary
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
        viewModel.nextButtonPressed()
        XCTAssertNil(outputHandler.didSetNameLabelError)
        XCTAssertNil(outputHandler.didSetCNICLabelError)
        XCTAssertNil(outputHandler.didSetCountryLabelError)
        XCTAssertNil(outputHandler.didSetMobileNumberLabelError)
        XCTAssertNil(outputHandler.didSetEmailLabelError)
        XCTAssertNotNil(outputHandler.didSetPassLabelError)
        XCTAssertNil(outputHandler.didSetRetypePassLabelError)
        XCTAssertNil(outputHandler.didSetAccountTypeLabelError)
        outputHandler.reset()
        router.reset()
        
        viewModel.name = Constants.name.rawValue
        viewModel.cnic = "1234512345671"
        (viewModel as? RegistrationViewModel)?.country = commonCountry
        viewModel.mobileNumber = "3215878488"
        viewModel.email = Constants.email.rawValue
        viewModel.paassword = nil
        viewModel.rePaassword = "Test@"
        (viewModel as? RegistrationViewModel)?.accountType = .beneficiary
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
        viewModel.nextButtonPressed()
        XCTAssertNil(outputHandler.didSetNameLabelError)
        XCTAssertNil(outputHandler.didSetCNICLabelError)
        XCTAssertNil(outputHandler.didSetCountryLabelError)
        XCTAssertNil(outputHandler.didSetMobileNumberLabelError)
        XCTAssertNil(outputHandler.didSetEmailLabelError)
        XCTAssertNotNil(outputHandler.didSetPassLabelError)
        XCTAssertNotNil(outputHandler.didSetRetypePassLabelError)
        XCTAssertNil(outputHandler.didSetAccountTypeLabelError)
        outputHandler.reset()
        router.reset()
        

//      Wrong Retype Pass
        viewModel.name = Constants.name.rawValue
        viewModel.cnic = "1234512345671"
        (viewModel as? RegistrationViewModel)?.country = commonCountry
        viewModel.mobileNumber = "3215878488"
        viewModel.email = Constants.email.rawValue
        viewModel.paassword = Constants.testPass.rawValue
        viewModel.rePaassword = "Test@12"
        (viewModel as? RegistrationViewModel)?.accountType = .beneficiary
        
        XCTAssertTrue(outputHandler.didSetNextButtonStateEnabled)
        viewModel.nextButtonPressed()
        XCTAssertNil(outputHandler.didSetNameLabelError)
        XCTAssertNil(outputHandler.didSetCNICLabelError)
        XCTAssertNil(outputHandler.didSetCountryLabelError)
        XCTAssertNil(outputHandler.didSetMobileNumberLabelError)
        XCTAssertNil(outputHandler.didSetEmailLabelError)
        XCTAssertNil(outputHandler.didSetPassLabelError)
        XCTAssertNotNil(outputHandler.didSetRetypePassLabelError)
        XCTAssertNil(outputHandler.didSetAccountTypeLabelError)
        outputHandler.reset()
        router.reset()
        
        
        viewModel.didSelect(accountType: nil)
        viewModel.nextButtonPressed()
        XCTAssertNil(outputHandler.didSetNameLabelError)
        XCTAssertNil(outputHandler.didSetCNICLabelError)
        XCTAssertNil(outputHandler.didSetCountryLabelError)
        XCTAssertNil(outputHandler.didSetMobileNumberLabelError)
        XCTAssertNil(outputHandler.didSetEmailLabelError)
        XCTAssertNil(outputHandler.didSetPassLabelError)
        XCTAssertNotNil(outputHandler.didSetRetypePassLabelError)
        XCTAssertNotNil(outputHandler.didSetAccountTypeLabelError)
        outputHandler.reset()
        router.reset()
        
    }
    
    func testAccountTypePickerViewModel() {
        var accountType = viewModel.accountTypePickerViewModel
        
        XCTAssertNotNil(accountType)
        XCTAssertEqual(accountType.data.count, 2)
        XCTAssertEqual(accountType.getItemTitle(at: 0), "Remitter")
        XCTAssertEqual(accountType.numberOfRows, 2)
        XCTAssertNotNil(accountType.getPickerModel(at: 0))
        XCTAssertEqual(accountType.getPickerModel(at: 0).key, "remitter")
        XCTAssertEqual(accountType.getPickerModel(at: 0).title, accountType.getItemTitle(at:0))
        
        accountType.setData(data: [ AccountTypePickerItemModel(title: AccountType.beneficiary.getTitle(), key: AccountType.beneficiary.rawValue)])
        
        XCTAssertNotNil(accountType)
        XCTAssertEqual(accountType.data.count, 1)
        XCTAssertEqual(accountType.getItemTitle(at: 0), "Beneficiary")
        XCTAssertEqual(accountType.numberOfRows, 1)
        XCTAssertNotNil(accountType.getPickerModel(at: 0))
        XCTAssertEqual(accountType.getPickerModel(at: 0).key, "beneficiary")
        XCTAssertEqual(accountType.getPickerModel(at: 0).title, accountType.getItemTitle(at:0))
    }
    
    func testAccountTypeProgress() {
        
        let outputHandler = RegistrationViewModelOutputHandler(registrationViewModel: viewModel)
        
        viewModel.didSelect(accountType: nil)
        
        XCTAssertEqual(outputHandler.didSetAccountTypeLabel, "")
        XCTAssertNil(outputHandler.progress)
        
        
        var accountType = AccountTypePickerItemModel(title: AccountType.beneficiary.getTitle(), key: AccountType.beneficiary.rawValue)
        viewModel.didSelect(accountType: accountType)
        XCTAssertEqual(outputHandler.didSetAccountTypeLabel, "Beneficiary")
        XCTAssertNotNil(outputHandler.progress)
        XCTAssertEqual(outputHandler.progress, 0.33)
        
        accountType = AccountTypePickerItemModel(title: AccountType.remitter.getTitle(), key: AccountType.remitter.rawValue)
        viewModel.didSelect(accountType: accountType)
        XCTAssertEqual(outputHandler.didSetAccountTypeLabel, "Remitter")
        XCTAssertNotNil(outputHandler.progress)
        XCTAssertEqual(outputHandler.progress, 0.25)
    }
    
    func testCountryTextFieldTapped() {
        let outputHandler = RegistrationViewModelOutputHandler(registrationViewModel: viewModel)
        
        viewModel.countryTextFieldTapped()
        Thread.sleep(forTimeInterval: 3)
        XCTAssertNotNil(outputHandler.didUpdateCountry)
        XCTAssertNotNil(outputHandler.didUpdateMobileCode)
        XCTAssertNotNil(outputHandler.didUpdateMobilePlaceholder)
        
        XCTAssertEqual(outputHandler.didUpdateCountry, "Pakistan")
        XCTAssertEqual(outputHandler.didUpdateMobileCode, "+92 - ")
        XCTAssertEqual(outputHandler.didUpdateMobilePlaceholder, "xxxxxxxxxx")
    }
    
    func testReEnterPassword() {
        
        let outputHandler = RegistrationViewModelOutputHandler(registrationViewModel: viewModel)
        
        viewModel.didReEnteredPassword(rePaassword: "Abc")
        XCTAssertNotNil(outputHandler.didSetRetypePassLabelError)
        XCTAssertEqual(outputHandler.didSetRetypePassLabelError, StringConstants.ErrorString.reEnterPaasswordError.localized)
        
        viewModel.paassword = "Abc@123"
        viewModel.didReEnteredPassword(rePaassword: "Abc@12345")
        XCTAssertNotNil(outputHandler.didSetRetypePassLabelError)
        XCTAssertEqual(outputHandler.didSetRetypePassLabelError, StringConstants.ErrorString.reEnterPaasswordError.localized)
        
        viewModel.paassword = "Abc@12345"
        viewModel.didReEnteredPassword(rePaassword: "Abc@12345")
        XCTAssertNil(outputHandler.didSetRetypePassLabelError)
        XCTAssertEqual(outputHandler.didSetRetypePassLabelError, nil)
    }
}

class RegistrationViewModelOutputHandler {
 
    var viewModel: RegistrationViewModelProtocol
    
    var didShowError: Error? = nil
    var didUpdateCountry: String? = nil
    var didUpdateMobileCode: String? = nil
    var didUpdateMobilePlaceholder: String? = nil
    var didSetNextButtonStateEnabled: Bool = false
    var didSetNextButtonStateDisabled: Bool = false
    var didSetNameLabelError: String? = nil
    var didSetCNICLabelError: String? = nil
    var didSetCountryLabelError: String? = nil
    var didSetMobileNumberLabelError: String? = nil
    var didSetEmailLabelError: String? = nil
    var didSetPassLabelError: String? = nil
    var didSetRetypePassLabelError: String? = nil
    var didSetAccountTypeLabelError: String? = nil
    var didSetAccountTypeLabel: String?
    var progress: Float?
    
    init(registrationViewModel: RegistrationViewModelProtocol) {
        self.viewModel = registrationViewModel
        setupObserver()
    }
    
    func reset() {
        didShowError = nil
        didUpdateCountry = nil
        didUpdateMobileCode = nil
        didUpdateMobilePlaceholder = nil
        didSetNextButtonStateEnabled = false
        didSetNextButtonStateDisabled = false
        didSetNameLabelError = nil
        didSetCNICLabelError = nil
        didSetCountryLabelError = nil
        didSetMobileNumberLabelError = nil
        didSetEmailLabelError = nil
        didSetPassLabelError = nil
        didSetRetypePassLabelError = nil
        didSetAccountTypeLabelError = nil
        didSetAccountTypeLabel = nil
        progress = nil
    }
    
    private func setupObserver() {
        viewModel.output = { output in
            switch output {
            case .showError(let error):
                self.didShowError = error
            case .updateCountry(let name):
                self.didUpdateCountry = name
            case .updateMobileCode(let code, _):
                self.didUpdateMobileCode = code
            case .updateMobilePlaceholder(let placeholder):
                self.didUpdateMobilePlaceholder = placeholder
            case .nextButtonState(let enableState):
                if enableState {
                    self.didSetNextButtonStateEnabled = true
                } else {
                    self.didSetNextButtonStateDisabled = false
                }
            case .nameTextField(_ , let error):
                self.didSetNameLabelError = error
            case .cnicTextField(_ , let error):
                self.didSetCNICLabelError = error
            case .countryTextField(_ , let error):
                self.didSetCountryLabelError = error
            case .mobileNumberTextField(_ , let error):
                self.didSetMobileNumberLabelError = error
            case .emailTextField(_ , let error):
                self.didSetEmailLabelError = error
            case .passwordTextField(_ , let error):
                self.didSetPassLabelError = error
            case .rePasswordTextField(_ , let error):
                self.didSetRetypePassLabelError = error
            case .accountTypeTextField(_ , let error):
                self.didSetAccountTypeLabelError = error
            case .updateAccountType(let accountType):
                self.didSetAccountTypeLabel = accountType
            case .updateProgressBar(let progress):
                self.progress = progress
            @unknown default:
                print ("default state")
            }
        }
    }
    
}

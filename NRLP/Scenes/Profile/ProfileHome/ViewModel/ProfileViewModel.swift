//
//  ProfileViewModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 17/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias ProfileViewModelOutput = (ProfileViewModel.Output) -> Void

protocol ProfileViewModelProtocol {
    var output: ProfileViewModelOutput? { get set }
    var name: String? { get }
    var cnic: String? { get }
    var mobileNumber: String? { get set }
    var email: String? { get set }
    var country: Country? { get set }
    var passportTypePickerViewModel: ItemPickerViewModel { get }
    var passportNumber: String? { get set }
    var passportType: PassportType? { get set }
    var residentID: String? { get set }
    
    func didSelectPassportType(passportType: PassportTypePickerItemModel?)
    func editButtonPressed()
    func cancelButtonPressed()
    func saveButtonPressed()
    func sendOtp()
    func countryTextFieldTapped()
    func viewDidLoad()
}

class ProfileViewModel: ProfileViewModelProtocol {
    private var router: ProfileRouter
    private var userProfileService: UserProfileServiceProtocol
    private var countryService: CountryServiceProtocol
    
    var user: UserModel!
    
    var editState: Bool = false
    var output: ProfileViewModelOutput?
    
    private var countries: [Country] = []
    
    var name: String? {
        return user.fullName
    }
    var cnic: String? {
        return "\(user.cnicNicop)"
    }
    var country: Country? {
        didSet {
            validateRequiredFields()
        }
    }
    var mobileNumber: String? {
        didSet {
            validateRequiredFields()
        }
    }
    var email: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var residentID: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var passportType: PassportType? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var passportNumber: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    var userEditedNumberWithCode: String {
        ((country?.code ?? "0") + (mobileNumber ?? ""))
    }
    
    var passportTypePickerViewModel: ItemPickerViewModel {
        return ItemPickerViewModel(data: [PassportTypePickerItemModel(title: PassportType.international.getTitle(), key: PassportType.international.rawValue), PassportTypePickerItemModel(title: PassportType.pakistani.getTitle(), key: PassportType.pakistani.rawValue)])
    }
    
    init(router: ProfileRouter,
         userProfileService: UserProfileServiceProtocol = UserProfileService(),
         countryService: CountryServiceProtocol = CountryService()) {
        self.router = router
        self.userProfileService = userProfileService
        self.countryService = countryService
    }
    
    func viewDidLoad() {
        output?(.editingReset)
        fetchUserProfile()
    }
    
    private func fetchUserProfile() {
        output?(.showActivityIndicator(show: true))
        self.userProfileService.getUserProfile { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if var user = response.data {
                    user.email = ["null", "undefined"].contains(user.email) ? "" : user.email
                    self.email = user.email
                    self.user = user
                    self.passportNumber = user.passportNumber
                    self.passportType = user.passportType
                    self.residentID = user.residentID
                    self.output?(.setUser(user: user))
                    self.fetchCountries()
                } else {
                    self.output?(.showActivityIndicator(show: false))
                    self.output?(.showError(error: .unknown))
                }
            case .failure(let error):
                self.output?(.showActivityIndicator(show: false))
                self.output?(.showError(error: error))
            }
        }
    }
    
    private func fetchCountries() {
        self.countryService.fetchCountries(accountType: AccountType.beneficiary) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if let countries = response.data,
                   let country = countries.filter({ $0.country == self.user.countryName ?? "" }).first {
                    self.country = country
                    self.user.userCountry = country
                    self.mobileNumber = self.user.mobileNo?.replacingOccurrences(of: country.code, with: "")
                    self.updateUserTelephonicDetails()
                } else {
                    self.output?(.showError(error: .unknown))
                }
            case .failure(let error):
                self.output?(.showActivityIndicator(show: false))
                self.output?(.showError(error: error))
            }
            self.output?(.showActivityIndicator(show: false))
        }
//        self.countryService.fetchCountries(accountType: user.accountType) { [weak self] (result) in
//            guard let self = self else { return }
//            switch result {
//            case .success(let response):
//                if let countries = response.data {
//                    self.countries = countries
//                    self.mapCountriesToUserNumber()
//                    if let userCountry = self.countries.filter({ $0.country.lowercased() == self.user.countryName?.lowercased() }).first {
//                        self.country = userCountry
//                        self.output?(.setCountry(country: userCountry))
//                    }
//                } else {
//                    self.output?(.showActivityIndicator(show: false))
//                    self.output?(.showError(error: .unknown))
//                }
//
//            case .failure(let error):
//                self.output?(.showActivityIndicator(show: false))
//                self.output?(.showError(error: error))
//            }
//        }
    }
    
    private func mapCountriesToUserNumber() {
        var matchedCountries: [Country] = []
        let userMobileNumber = self.user.mobileNo
        
        self.countries.forEach { (country) in
            let userMobileNumberCodeLength = (userMobileNumber?.count ?? 0) - country.length
            if userMobileNumberCodeLength > 0,
                let extractedCode = userMobileNumber?.prefix(userMobileNumberCodeLength),
                country.code == String(extractedCode) {
                matchedCountries.append(country)
            }
        }
        
        self.country = matchedCountries.first
        if user.mobileNo?.hasPrefix(self.country?.code ?? "") ?? false {
            let mobileNumb = user.mobileNo ?? ""
            self.mobileNumber = String(mobileNumb.suffix(mobileNumb.count - (country?.code.count ?? 0)))
        }
        updateUserTelephonicDetails()
        output?(.showActivityIndicator(show: false))
    }
    
    private func updateUserTelephonicDetails() {
        self.output?(.updateCountry(country: self.country))
        self.output?(.updateMobileCode(code: "\(self.country?.code ?? "") - ", length: 0))
        self.output?(.setMobileNumber(number: self.mobileNumber ?? ""))
//        let userMobileNumber = self.user.mobileNo
//        output?(.updateCountry(country: self.country))
//        output?(.updateMobileCode(code: "\(self.country?.code ?? "") - ", length: country?.length ?? 0))
//
//        let extractedMobileNumber = String(userMobileNumber?.suffix(country?.length ?? 0) ?? "")
//        user.mobileNo = extractedMobileNumber
//        user.userCountry = self.country
//        output?(.setMobileNumber(number: extractedMobileNumber))
        
    }
    
    func editButtonPressed() {
        router.navigateToNadraVerificationScreen { isVerified in
            if isVerified {
                self.editState = true
                self.output?(.editingEnabled)
            }
        }
    }
    
    func cancelButtonPressed() {
        //reset all data
        self.country = user.userCountry
        editState = false
        output?(.editingReset)
        output?(.setUser(user: self.user))
        if let country = country {
            self.mobileNumber = self.user.mobileNo?.replacingOccurrences(of: country.code, with: "")
        }
        self.passportNumber = user.passportNumber
        // self.country = user.userCountry
        updateUserTelephonicDetails()
    }
    
    func saveButtonPressed() {
        if !validateDataWithRegex() {
            return
        }
        
        let alert = AlertViewModel(alertHeadingImage: .ohSnap, alertTitle: "Update Profile".localized, alertDescription: "Are you sure you want to update your profile?".localized, primaryButton: AlertActionButtonModel(buttonTitle: "Yes".localized, buttonAction: {
            if self.checkMobileNumberUpdated() {
                self.sendOtp()
            } else {
                self.saveUserDetails()
            }
        }), secondaryButton: AlertActionButtonModel(buttonTitle: "No".localized, buttonAction: nil))
        
        output?(.showAlert(alert: alert))
        
    }
    
    func sendOtp() {
        self.output?(.showActivityIndicator(show: true))
        userProfileService.updateUserSendOTP(requestModel: UpdateProfileSendOTPRequestModel(email: getEmail(), mobileNumber: getNumber(), passportNumber: getPassportNumber(), passportType: getPassportType(), residentID: getResidentID(), country: getCountry())) {[weak self] (result) in
            guard let self = self else { return }
            self.output?(.showActivityIndicator(show: false))
            switch result {
            case .success:
                self.moveToOTPScreen()
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        }
    }
    
    private func saveUserDetails() {
        self.output?(.showActivityIndicator(show: true))
        let model = UpdateProfileSendOTPRequestModel(email: getEmail(), mobileNumber: nil, passportNumber: getPassportNumber(), passportType: getPassportType(), residentID: getResidentID(), country: getCountry())
        userProfileService.updateProfile(requestModel: model) { (result) in
            self.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(_):
                self.router.navigateToSuccess()
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        }
    }
    
    func moveToOTPScreen() {
        let requestModel = UpdateProfileSendOTPRequestModel(email: getEmail(), mobileNumber: getNumber(), passportNumber: getPassportNumber(), passportType: getPassportType(), residentID: getResidentID(), country: getCountry())
        let model = ProfileUpdateModel(profileUpdateRequestModel: requestModel, userModel: user)
        router.navigateToOTPScreen(model: model)
    }
    
    func getRequestModel() -> UpdateProfileSendOTPRequestModel {
        return UpdateProfileSendOTPRequestModel(email: getEmail(), mobileNumber: getNumber(), passportNumber: getPassportNumber(), passportType: getPassportType(), residentID: getResidentID(), country: getCountry())
    }
    
    func moveToSuccessScreen() {
        router.navigateToSuccess()
    }
    
    func checkMobileNumberUpdated() -> Bool {
        let numberWithCode = userEditedNumberWithCode
        return numberWithCode != user.mobileNo
    }
    
    func countryTextFieldTapped() {
        if editState {
            router.navigateToCountryPicker(onSelectionCountry: { [weak self] selectedCountry in
                if self?.country != selectedCountry {
                    self?.country = selectedCountry
                    self?.output?(.updateCountry(country: selectedCountry))
                    self?.output?(.updateMobileCode(code: selectedCountry.code + " - ", length: selectedCountry.length))
                    self?.output?(.updateMobilePlaceholder(placeholder: Array(repeating: "x", count: selectedCountry.length).joined()))
                }
            }, accountType: user.accountType ?? .remitter)
        }
    }
    
    func getCountry() -> String? {
        let country = self.country?.country ?? ""
        if country == user.countryName {
            return nil
        }
        return country
    }
    
    func getEmail() -> String? {
        var usrEmail = email
        usrEmail = usrEmail == user.email ? nil : usrEmail
        return usrEmail
    }
    
    func getResidentID() -> String? {
        var usrResidentID = residentID
        usrResidentID = usrResidentID == user.residentID ? nil : usrResidentID
        return usrResidentID
    }
    
    func getPassportNumber() -> String? {
        var usrPassportNumber = passportNumber
        usrPassportNumber = usrPassportNumber == user.passportNumber ? nil : usrPassportNumber
        return usrPassportNumber
    }
    
    func getPassportType() -> String? {
        let usrPassportType = passportType?.rawValue
        if user.passportType == self.passportType {
           return nil
        }
        if user.passportNumber == self.passportNumber {
            return ""
        }
        return usrPassportType
    }
    
    func getNumber() -> String? {
        var mobNumber: String? =  userEditedNumberWithCode
        mobNumber = mobNumber == ((user.userCountry?.code ?? "0") + (user.mobileNo ?? "")) ? nil : mobNumber ?? ""
        return mobNumber
    }
    
    func didSelectPassportType(passportType: PassportTypePickerItemModel?) {
        self.passportType = passportType?.passportType
        output?(.updatePassportType(passportType: self.passportType?.getTitle() ?? ""))
    }
    
    enum Output {
        case updateCountry(country: Country?)
        case updateMobileCode(code: String, length: Int)
        case updateMobilePlaceholder(placeholder: String)
        case updatePassportType(passportType: String)
        case nextButtonState(enableState: Bool)
        case nameTextField(errorState: Bool, error: String?)
        case cnicTextField(errorState: Bool, error: String?)
        case countryTextField(errorState: Bool, error: String?)
        case mobileNumberTextField(errorState: Bool, error: String?)
        case emailTextField(errorState: Bool, error: String?)
        case showAlert(alert: AlertViewModel)
        case editingEnabled
        case editingReset
        case setUser(user: UserModel)
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case setMobileNumber(number: String)
        case passportNumberTextField(errorState: Bool, error: String?)
        case passportTypeTextField(errorState: Bool, error: String?)
        case residentIDTextField(errorState: Bool, error: String?)
        case setCountry(country: Country)
    }
}

extension ProfileViewModel {
    private func validateRequiredFields() {
        // unique id
        // passport type
        // passport number
        // residence country
        // mobile number
        // email address
        
        let userMobileNumberWithCode = ((user?.userCountry?.code ?? "0") + (user?.mobileNo ?? ""))
        
        if residentID?.isBlank ?? true || passportType == nil || passportNumber?.isBlank ?? true || country == nil || mobileNumber?.isBlank ?? true {
            self.output?(.nextButtonState(enableState: false))
        } else if user.residentID == residentID && user.passportType == passportType && user.passportNumber == passportNumber && user.userCountry == country {
            self.output?(.nextButtonState(enableState: false))
        }
        
if userEditedNumberWithCode == userMobileNumberWithCode && user?.email == email && editState && user.passportType == passportType && user.passportNumber == passportNumber && user.residentID == residentID {
            output?(.nextButtonState(enableState: false))
        } else {
            output?(.nextButtonState(enableState: true))
        }
    }
    
    private func validateDataWithRegex() -> Bool {
        var isValid: Bool = true
        
        if country != nil {
            output?(.countryTextField(errorState: false, error: nil))
        } else {
            output?(.countryTextField(errorState: true, error: StringConstants.ErrorString.countryError.localized))
            isValid = false
        }
        
        if country != nil && !(mobileNumber?.isBlank ?? true) {
            output?(.mobileNumberTextField(errorState: false, error: nil))
        } else {
            output?(.mobileNumberTextField(errorState: true, error: StringConstants.ErrorString.mobileNumberError.localized))
            isValid = false
        }
        
        if email == nil || email?.isEmpty ?? true || email?.isValid(for: RegexConstants.emailRegex) ?? false {
            output?(.emailTextField(errorState: false, error: nil))
        } else {
            output?(.emailTextField(errorState: true, error: StringConstants.ErrorString.emailError.localized))
            isValid = false
        }
        
        if user.type?.lowercased() == AccountType.remitter.rawValue.lowercased() {
            if passportNumber != nil && !(passportNumber?.isEmpty ?? true) && passportNumber?.isValid(for: RegexConstants.passportRegex) ?? false {
                output?(.passportNumberTextField(errorState: false, error: nil))
            } else {
                output?(.passportNumberTextField(errorState: true, error: StringConstants.ErrorString.passportNumberError.localized))
                isValid = false
            }
            
            if !(passportType?.rawValue.isEmpty ?? true) {
                output?(.passportTypeTextField(errorState: false, error: nil))
            } else {
                output?(.passportTypeTextField(errorState: true, error: StringConstants.ErrorString.passportNumberError.localized))
                isValid = false
            }
            
            if residentID != nil && !(residentID?.isEmpty ?? true) {
                output?(.residentIDTextField(errorState: false, error: nil))
            } else {
                output?(.residentIDTextField(errorState: true, error: StringConstants.ErrorString.residentIdError.localized))
                isValid = false
            }
        }
        return isValid
    }
}

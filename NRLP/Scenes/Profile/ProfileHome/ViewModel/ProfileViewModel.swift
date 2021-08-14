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
    
    var userEditedNumberWithCode: String {
        ((country?.code ?? "0") + (mobileNumber ?? ""))
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
                    user.email = user.email == "null" ? "" : user.email
                    self.email = user.email
                    self.user = user
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
        self.countryService.fetchCountries { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if let countries = response.data {
                    self.countries = countries
                    self.mapCountriesToUserNumber()
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
        let userMobileNumber = self.user.mobileNo
        output?(.updateCountry(country: self.country))
        output?(.updateMobileCode(code: "\(self.country?.code ?? "") - ", length: country?.length ?? 0))
        
        let extractedMobileNumber = String(userMobileNumber?.suffix(country?.length ?? 0) ?? "")
        user.mobileNo = extractedMobileNumber
        user.userCountry = self.country
        output?(.setMobileNumber(number: extractedMobileNumber))
        
    }
    
    func editButtonPressed() {
        editState = true
        output?(.editingEnabled)
    }
    
    func cancelButtonPressed() {
        //reset all data
        editState = false
        output?(.editingReset)
        output?(.setUser(user: self.user))
        updateUserTelephonicDetails()
    }
    
    func saveButtonPressed() {
        if !validateDataWithRegex() {
            return
        }
        
        let alert = AlertViewModel(alertHeadingImage: .ohSnap, alertTitle: "Update Profile".localized, alertDescription: "Are you sure you want to update your profile?".localized, primaryButton: AlertActionButtonModel(buttonTitle: "Yes".localized, buttonAction: {
            self.sendOtp()
        }), secondaryButton: AlertActionButtonModel(buttonTitle: "No".localized, buttonAction: nil))
        
        output?(.showAlert(alert: alert))
        
    }
    
    func sendOtp() {
        self.output?(.showActivityIndicator(show: true))
        userProfileService.updateUserSendOTP(requestModel: UpdateProfileSendOTPRequestModel(email: getEmail(), mobileNumber: getNumber())) {[weak self] (result) in
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
    
    func moveToOTPScreen() {
        let requestModel = UpdateProfileSendOTPRequestModel(email: getEmail(), mobileNumber: getNumber())
        let model = ProfileUpdateModel(profileUpdateRequestModel: requestModel, userModel: user)
        router.navigateToOTPScreen(model: model)
    }
    
    func getRequestModel() -> UpdateProfileSendOTPRequestModel {
        return UpdateProfileSendOTPRequestModel(email: getEmail(), mobileNumber: getNumber())
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
            })
        }
    }
    
    func getEmail() -> String? {
        var usrEmail = email
        usrEmail = usrEmail == user.email ? nil : usrEmail
        return usrEmail
    }
    
    func getNumber() -> String? {
        var mobNumber: String? =  userEditedNumberWithCode
        mobNumber = mobNumber == ((user.userCountry?.code ?? "0") + (user.mobileNo ?? "")) ? nil : mobNumber ?? ""
        return mobNumber
    }
    
    enum Output {
        case updateCountry(country: Country?)
        case updateMobileCode(code: String, length: Int)
        case updateMobilePlaceholder(placeholder: String)
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
    }
}

extension ProfileViewModel {
    private func validateRequiredFields() {
        let userMobileNumberWithCode = ((user?.userCountry?.code ?? "0") + (user?.mobileNo ?? ""))
        if userEditedNumberWithCode == userMobileNumberWithCode && user?.email == email && editState {
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
        
        if country != nil && mobileNumber?.count ?? 0 == country?.length {
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
        
        return isValid
    }
}

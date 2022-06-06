//
//  ProfileVerificationViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 08/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias ProfileVerificationViewModelOutput = (ProfileVerificationViewModel.Output) -> Void

protocol ProfileVerificationViewModelProtocol {
    
    var output: ProfileVerificationViewModelOutput? { get set }
    var motherName: String? { get set }
    
    func nextButtonPressed()
    
}

class ProfileVerificationViewModel: ProfileVerificationViewModelProtocol {
    
    private var router: ProfileVerificationRouter
    private let service: UserProfileServiceProtocol
    private var logoutService: LogoutService = LogoutService()
    private var isVerifiedCallBack: NadraVerifiedCallBack?
    
    var output: ProfileVerificationViewModelOutput?
    
    var motherName: String? {
        didSet {
            validateRequiredFields()
        }
    }
    
    func nextButtonPressed() {
        let isValid = validateDataRegex()
        
        if isValid {
            // API Call here
            output?(.showActivityIndicator(show: true))
            let requestModel = UpdateProfileVerificationRequestModel(motherMaidenName: self.motherName ?? "")
            service.verifyProfile(requestModel: requestModel) { result in
                self.output?(.showActivityIndicator(show: false))
                switch result {
                case .success(_) :
                    self.isVerifiedCallBack?(true)
                    self.router.popToPreviousScreen()
                case .failure(let error):
                    switch error {
                    case .server(let response):
                        if response?.errorCode.lowercased() == "".lowercased() {
                            let alert = AlertViewModel(alertHeadingImage: .ohSnap, alertTitle: "Unsuccessful".localized, alertDescription: "Your provided information is incorrect. Kindly enter the valid information as per NADRA record", primaryButton: AlertActionButtonModel(buttonTitle: "OK".localized, buttonAction: {
                                self.isVerifiedCallBack?(false)
                                self.router.popToPreviousScreen()
                            }))
                            self.output?(.showAlert(alert: alert))
                        } else if response?.errorCode.lowercased() == "GEN-ERR-53".lowercased() {
                            let alert = AlertViewModel(alertHeadingImage: .ohSnap, alertTitle: "Oh Snap!".localized, alertDescription: "Your account has been locked due to 3 unsuccessful attempts, You can click on forget password to unlock your account", primaryButton: AlertActionButtonModel(buttonTitle: "OK".localized, buttonAction: {
                                self.isVerifiedCallBack?(false)
                                self.logoutUser()
                            }))
                            self.output?(.showAlert(alert: alert))
                        }
                    default:
                        self.output?(.showError(error: error))
                    }
                    self.output?(.showError(error: error))
                }
            }
        }
    }
    
    init(with router: ProfileVerificationRouter,
         service: UserProfileServiceProtocol = UserProfileService(),
         isVerifiedCallBack: @escaping NadraVerifiedCallBack) {
        self.router = router
        self.service = service
        self.isVerifiedCallBack = isVerifiedCallBack
    }
    
    enum Output {
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case updateMotherTextFieldState(errorState: Bool, errorMessage: String?)
        case nextButtonState(enableState: Bool)
        case showAlert(alert: AlertViewModel)
        
    }
    
    private func validateDataRegex() -> Bool {
        var isValid = true
        if motherName?.isValid(for: RegexConstants.nameRegex) ?? false {
            output?(.updateMotherTextFieldState(errorState: false, errorMessage: nil))
        } else {
            isValid = false
            output?(.updateMotherTextFieldState(errorState: true, errorMessage: StringConstants.ErrorString.fullNameError.localized))
        }
        return isValid
    }
    
    private func validateRequiredFields() {
        if motherName?.isBlank ?? false {
            output?(.nextButtonState(enableState: false))
        } else {
            output?(.nextButtonState(enableState: true))
        }
    }
    
    private func logoutUser() {
        output?(.showActivityIndicator(show: true))
        logoutService.logoutUser { [weak self] (_) in
            guard let self = self else { return }
            self.output?(.showActivityIndicator(show: false))
            self.router.navigateToLoginScreen()
        }
    }
}

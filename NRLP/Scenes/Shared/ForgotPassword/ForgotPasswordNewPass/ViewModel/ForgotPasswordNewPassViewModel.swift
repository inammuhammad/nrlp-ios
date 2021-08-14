//
//  ForgotPasswordNewPassViewModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 15/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias ForgotPasswordNewPassViewModelOutput = (ForgotPasswordNewPassViewModel.Output) -> Void

protocol ForgotPasswordNewPassViewModelProtocol {
    var output: ForgotPasswordNewPassViewModelOutput? { get set}
    var newPassword: String? { get set }
    var redoNewPassword: String? { get set }

    func validateConfirmPassword()
    func didTapBackButton()
    func navigateToFinishScreen()
}

class ForgotPasswordNewPassViewModel: ForgotPasswordNewPassViewModelProtocol {

    private var router: ForgotPasswordNewPassRouter
    private var forgotPasswordRequestModel: ForgotPasswordSendOTPRequest
    private var service: ForgotPasswordService

    init(router: ForgotPasswordNewPassRouter, forgotPasswordRequestModel: ForgotPasswordSendOTPRequest, service: ForgotPasswordService = ForgotPasswordService()) {
        self.router = router
        self.forgotPasswordRequestModel = forgotPasswordRequestModel
        self.service = service
    }

    func navigateToFinishScreen() {
        if !validateDataWithRegex() {
            return
        } else {
            output?(.showActivityIndicator(show: true))
            service.updatePassword(requestModel: UpdatePasswordRequest(nicNicop: forgotPasswordRequestModel.nicNicop, userType: forgotPasswordRequestModel.userType, password: newPassword ?? "")) {[weak self] (result) in
                self?.output?(.showActivityIndicator(show: false))
                switch result {
                case .success(let response):
                    print("New Password response: \(response)")
                    self?.moveToSuccess()
                case .failure(let error):
                    print("New Password response: \(error)")
                    self?.output?(.showError(error: error))
                }
            }
        }
    }

    var output: ForgotPasswordNewPassViewModelOutput?

    var newPassword: String? {
        didSet {
            validateRequiredFields()
        }
    }

    var redoNewPassword: String? {
        didSet {
            validateRequiredFields()
        }
    }

    private func moveToSuccess() {
        self.router.navigateToSuccess()
    }

    func didTapBackButton() {
        router.navigateBackToForgotPasswordScreen()
    }

    internal func validateConfirmPassword() {
        self.validateConfirmPasswordField()
    }

    enum Output {
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case nextButtonState(enableState: Bool)
        case newPasswordTextField(errorState: Bool, error: String?)
        case retypeNewPasswordTypeTextField(errorState: Bool, error: String?)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

extension ForgotPasswordNewPassViewModel {

    private func validateRequiredFields() {
        if newPassword?.isBlank ?? true || redoNewPassword?.isBlank ?? true {
            output?(.nextButtonState(enableState: false))
        } else {
            output?(.nextButtonState(enableState: true))
        }
    }

    private func validateConfirmPasswordField() {
        if newPassword == redoNewPassword {
            output?(.retypeNewPasswordTypeTextField(errorState: false, error: nil))
        } else {
            output?(.retypeNewPasswordTypeTextField(errorState: true, error: StringConstants.ErrorString.reEnterPaasswordError.localized))
        }
    }

    private func validateDataWithRegex() -> Bool {
        var isValid: Bool = true

        if newPassword?.isValid(for: RegexConstants.paasswordRegex) ?? false {
            output?(.newPasswordTextField(errorState: false, error: nil))
        } else {
            output?(.newPasswordTextField(errorState: true, error: StringConstants.ErrorString.paasswordError.localized))
            isValid = false
        }

        if redoNewPassword?.isValid(for: RegexConstants.paasswordRegex) ?? false {
            output?(.retypeNewPasswordTypeTextField(errorState: false, error: nil))
        } else {
            output?(.retypeNewPasswordTypeTextField(errorState: true, error: StringConstants.ErrorString.paasswordError.localized))
            isValid = false
        }

        if redoNewPassword?.isValid(for: RegexConstants.paasswordRegex) ?? false && newPassword == redoNewPassword {
            output?(.retypeNewPasswordTypeTextField(errorState: false, error: nil))
        } else {
            output?(.retypeNewPasswordTypeTextField(errorState: true, error: StringConstants.ErrorString.reEnterPaasswordError.localized))
            isValid = false
        }

        return isValid
    }
}

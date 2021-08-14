//
//  ChangePasswordViewModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 16/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//
import Foundation

typealias ChangePasswordViewModelOutput = (ChangePasswordViewModel.Output) -> Void

protocol ChangePasswordViewModelProtocol {
    var output: ChangePasswordViewModelOutput? { get set}
    var oldPaassword: String? { get set }
    var paassword: String? { get set }
    var rePaassword: String? { get set }

    func validateConfirmPassword()
    func doneButtonPressed()
}

class ChangePasswordViewModel: ChangePasswordViewModelProtocol {

    var output: ChangePasswordViewModelOutput?

    private var service: ChangePasswordServiceProtocol?
    private var router: ChangePasswordRouter

    var oldPaassword: String? {
        didSet {
            validateRequiredFields()
        }
    }

    var paassword: String? {
        didSet {
            validateRequiredFields()
        }
    }

    var rePaassword: String? {
        didSet {
            validateRequiredFields()
        }
    }

    init(router: ChangePasswordRouter, service: ChangePasswordServiceProtocol = ChangePasswordService()) {
        self.router = router
        self.service = service
    }

    func validateConfirmPassword() {
        self.validateConfirmPasswordField()
    }

    private func validateConfirmPasswordField() {
        if paassword == rePaassword {
            output?(.rePasswordTextField(errorState: false, error: nil))
        } else {
            output?(.rePasswordTextField(errorState: true, error: StringConstants.ErrorString.reEnterPaasswordError.localized))
        }
    }

    func doneButtonPressed() {
        if !validateDataWithRegex() {
            return
        }

        output?(.showActivityIndicator(show: true))
        service?.changePassword(requestModel: ChangePasswordRequestModel(oldPassword: oldPaassword ?? "", newPassword: paassword ?? ""), responseHandler: { [weak self] (response) in
            guard let self = self else { return }
            self.output?(.showActivityIndicator(show: false))
            switch response {
            case .success:
                self.router.navigateToSuccess()
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        })
    }

    enum Output {
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case doneButtonState(enableState: Bool)
        case oldPasswordTextField(errorState: Bool, error: String?)
        case passwordTextField(errorState: Bool, error: String?)
        case rePasswordTextField(errorState: Bool, error: String?)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

extension ChangePasswordViewModel {
    private func validateRequiredFields() {
        if oldPaassword?.isBlank ?? true || paassword?.isBlank ?? true || rePaassword?.isBlank ?? true {
            output?(.doneButtonState(enableState: false))
        } else {
            output?(.doneButtonState(enableState: true))
        }
//        if password?.isValid(for: RegexConstants.passwordRegex) ?? false && password == oldPassword {
//            output?(.passwordTextField(errorState: true, error: StringConstants.ErrorString.sameAsOldPasswordError))
//        }
    }

    private func validateDataWithRegex() -> Bool {
        var isValid: Bool = true

        if (oldPaassword ?? "").count >= 8 {
            output?(.oldPasswordTextField(errorState: false, error: nil)) // Changed during Unit Testing
        } else {
            output?(.oldPasswordTextField(errorState: true, error: StringConstants.ErrorString.incorrectOldPaassword.localized)) // Changed during Unit Testing
            isValid = false
        }

        if paassword?.isValid(for: RegexConstants.paasswordRegex) ?? false {
            output?(.passwordTextField(errorState: false, error: nil))
        } else {
            output?(.passwordTextField(errorState: true, error: StringConstants.ErrorString.createPaasswordError.localized))
            isValid = false
        }

//        if rePassword?.isValid(for: RegexConstants.passwordRegex) ?? false && // Changed during Unit Testing
          if paassword == rePaassword {
            output?(.rePasswordTextField(errorState: false, error: nil))
        } else {
            output?(.rePasswordTextField(errorState: true, error: StringConstants.ErrorString.reEnterPaasswordError.localized))
            isValid = false
        }

//        if password?.isValid(for: RegexConstants.passwordRegex) ?? false && password == oldPassword {
//            isValid = false
//            output?(.passwordTextField(errorState: true, error: StringConstants.ErrorString.sameAsOldPasswordError))
//        }

        return isValid
    }
}

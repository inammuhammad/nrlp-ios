//
//  ForgotPasswordViewModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 14/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias ForgotPasswordViewModelOutput = (ForgotPasswordViewModel.Output) -> Void

protocol ForgotPasswordViewModelProtocol {
    var output: ForgotPasswordViewModelOutput? { get set}
    var accountTypePickerViewModel: ItemPickerViewModel { get }
    var cnic: String? { get set }

    func nextButtonPressed()
    func didSelect(accountType: AccountTypePickerItemModel?)
}

class ForgotPasswordViewModel: ForgotPasswordViewModelProtocol {

    init(router: ForgotPasswordRouter, service: ForgotPasswordService) {
        self.router = router
        self.service = service
    }

    var output: ForgotPasswordViewModelOutput?

    private var router: ForgotPasswordRouter
    private var service: ForgotPasswordService

    var accountTypePickerViewModel: ItemPickerViewModel {
        return ItemPickerViewModel(data: [AccountTypePickerItemModel(title: AccountType.remitter.getTitle(), key: AccountType.remitter.rawValue), AccountTypePickerItemModel(title: AccountType.beneficiary.getTitle(), key: AccountType.beneficiary.rawValue)])
    }

    var cnic: String? {
        didSet {
            validateRequiredFields()
        }
    }

    private var accountType: AccountType? {
        didSet {
            validateRequiredFields()
        }
    }

    func nextButtonPressed() {
        if !validateDataWithRegex() {
            return
        }

        output?(.showActivityIndicator(show: true))

        let requestModel = ForgotPasswordSendOTPRequest(nicNicop: cnic ?? "", userType: accountType?.rawValue ?? "")

        service.sendOTP(requestModel: requestModel) {[weak self] (result) in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                print("Verify OTP Successful: \(response)")
                self?.router.navigateToOTPScreen(forgotPasswordRequestModel: requestModel)
            case .failure(let error):
                print("Verify OTP Request Fail With Error: \(error)")
                self?.output?(.showError(error: error))
            }
        }

    }

    func didSelect(accountType: AccountTypePickerItemModel?) {
        self.accountType = accountType?.accountType
        output?(.updateAccountType(accountType: self.accountType?.getTitle() ?? ""))
    }

    enum Output {
        case showError(error: APIResponseError)
        case showActivityIndicator(show: Bool)
        case nextButtonState(enableState: Bool)
        case cnicTextField(errorState: Bool, error: String?)
        case accountTypeTextField(errorState: Bool, error: String?)
        case updateAccountType(accountType: String)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

extension ForgotPasswordViewModel {
    private func validateRequiredFields() {
        if cnic?.isBlank ?? true || accountType == nil {
            output?(.nextButtonState(enableState: false))
        } else {
            output?(.nextButtonState(enableState: true))
        }
    }

    private func validateDataWithRegex() -> Bool {
        var isValid: Bool = true

        if cnic?.isValid(for: RegexConstants.cnicRegex) ?? false {
            output?(.cnicTextField(errorState: false, error: nil))
        } else {
            output?(.cnicTextField(errorState: true, error: StringConstants.ErrorString.cnicError.localized))
            isValid = false
        }

        if accountType != nil {
            output?(.accountTypeTextField(errorState: false, error: nil))
        } else {
            output?(.accountTypeTextField(errorState: true, error: StringConstants.ErrorString.accountTypeError.localized))
            isValid = false
        }

        return isValid
    }

}

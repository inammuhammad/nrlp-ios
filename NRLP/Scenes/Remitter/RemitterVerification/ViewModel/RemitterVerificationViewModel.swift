//
//  RemitterVerificationViewModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias RemitterVerificationViewModelOutput = (RemitterVerificationViewModel.Output) -> Void

protocol RemitterVerificationViewModelProtocol {

    var output: RemitterVerificationViewModelOutput? { get set}
    func nextButtonPressed()
    var referenceNumber: String? { get set }
    var transactionAmount: String? { get set }
}

class RemitterVerificationViewModel: RemitterVerificationViewModelProtocol {

    private var service: APIKeyServiceDecorator<RemitterVerificationServiceProtocol>
    private var router: RemitterVerificationRouter
    var output: RemitterVerificationViewModelOutput?
    private var registerModel: RegisterRequestModel

    var referenceNumber: String? {
        didSet {
            validateRequiredFields()
        }
    }

    var transactionAmount: String? {
        didSet {
            validateRequiredFields()
        }
    }

    enum Output {
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case nextButtonState(state: Bool)
        case referenceNumberLabelState(error: Bool, message: String?)
        case transactionAmountLabelState(error: Bool, message: String?)
    }

    init(service: APIKeyServiceDecorator<RemitterVerificationServiceProtocol>,
         router: RemitterVerificationRouter,
         model: RegisterRequestModel) {

        self.service = service
        self.router = router
        self.registerModel = model
    }

    func nextButtonPressed() {

        if !validateDataWithRegex() {
            return
        }

        let requestModel = VerifyReferenceNumberRequestModel(amount: self.transactionAmount ?? "0", mobileNo: registerModel.mobileNo, nicNicop: registerModel.cnicNicop, referenceNo: self.referenceNumber ?? "0000", userType: registerModel.accountType)

        output?(.showActivityIndicator(show: true))
        service.dispatchForKey(cnic: requestModel.nicNicop, type: .remitter) {[weak self] (error) in
            guard error == nil else {
                self?.output?(.showActivityIndicator(show: false))
                self?.output?(.showError(error: error!))
                return
            }
            guard let self = self else { return }
            self.service.decoratee.verifyCode(requestModel: requestModel) { [weak self] (result) in

                self?.output?(.showActivityIndicator(show: false))
                switch result {
                case .success:
                    self?.moveToNext()
                case .failure(let error):
                    print("Login Request Fail With Error: \(error)")
                    self?.output?(.showError(error: error))
                }
            }
        }

    }

    private func moveToNext() {
        registerModel.transactionRefNo = referenceNumber
        registerModel.transactionAmount = transactionAmount

        router.navigateToNextScreen(model: registerModel)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

extension RemitterVerificationViewModel {

    private func validateRequiredFields() {
        if referenceNumber?.isBlank ?? true || transactionAmount?.isBlank ?? true || (transactionAmount?.double ?? 0) <= 0 {
            output?(.nextButtonState(state: false))
        } else {
            output?(.nextButtonState(state: true))
        }
    }

    private func validateDataWithRegex() -> Bool {
        var isValid: Bool = true

        if referenceNumber?.isValid(for: RegexConstants.referenceNumberRegex) ?? false {
            output?(.referenceNumberLabelState(error: false, message: nil))
        } else {
            output?(.referenceNumberLabelState(error: true, message: StringConstants.ErrorString.referenceNumberError.localized))
            isValid = false
        }

        if transactionAmount?.isValid(for: RegexConstants.transactionAmountRegex) ?? false {
            output?(.transactionAmountLabelState(error: false, message: nil))
        } else {
            output?(.transactionAmountLabelState(error: true, message: StringConstants.ErrorString.transactionAmountError.localized))
            isValid = false
        }

        return isValid
    }
}

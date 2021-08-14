//
//  AddBeneficiaryViewModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias AddBeneficiaryViewModelOutput = (AddBeneficiaryViewModel.Output) -> Void

protocol AddBeneficiaryViewModelProtocol {
    var output: AddBeneficiaryViewModelOutput? { get set}
    var name: String? { get set }
    var cnic: String? { get set }
    var mobileNumber: String? { get set }

    func addButtonPressed()
    func openCountryPicker()

}

class AddBeneficiaryViewModel: AddBeneficiaryViewModelProtocol {

    func openCountryPicker() {
        router.navigateToCountryPicker(with: { [weak self] selectedCountry in
            if selectedCountry != self?.country {
                self?.output?(.updateMobileCode(code: selectedCountry.code + " - "))
                self?.output?(.updateMobilePlaceholder(placeholder: Array(repeating: "x", count: selectedCountry.length).joined(), length: selectedCountry.length))
                self?.output?(.updateCountry(countryName: selectedCountry.country))
                self?.country = selectedCountry
            }
        })
    }

    var output: AddBeneficiaryViewModelOutput?
    private var router: AddBeneficiaryRouter
    private var service: ManageBeneficiaryServiceProtocol

    private var country: Country?

    var name: String? {
        didSet {
            validateRequiredFields()
        }
    }

    var cnic: String? {
        didSet {
            validateRequiredFields()
        }
    }

    var mobileNumber: String? {
        didSet {
            validateRequiredFields()
        }
    }

    init(router: AddBeneficiaryRouter, service: ManageBeneficiaryServiceProtocol) {
        self.router = router
        self.service = service
    }

    func addButtonPressed() {
        if !validateDataWithRegex() {
            return
        }
        output?(.showActivityIndicator(show: true))
        let mobNumber = "\(country?.code ?? "")\(mobileNumber ?? "")"
        service.addBeneficiary(beneficiary: AddBeneficiaryRequestModel(beneficiaryAlias: name, beneficiaryMobileNo: mobNumber, beneficiaryNicNicop: cnic)) { [weak self] (result) in
            self?.output?(.showActivityIndicator(show: false))
            guard let self = self else { return }
            self.output?(.showActivityIndicator(show: false))

            switch result {
            case .success:
                let model = AlertViewModel(alertHeadingImage: .successAlert, alertTitle: "Beneficiary Added".localized, alertDescription: "Beneficiary created successfully, we have sent a SMS to the Beneficiary.".localized, primaryButton: AlertActionButtonModel(buttonTitle: "Done".localized, buttonAction: {
                    self.router.popToPreviousScreen()
                }), secondaryButton: nil)

                self.output?(.showAlert(alert: model))
            case .failure(let error):
                self.output?(.showError(error: error))
            }

        }
    }

    enum Output {
        case showError(error: APIResponseError)
        case addButtonState(enableState: Bool)
        case nameTextField(errorState: Bool, errorMessage: String?)
        case cnicTextField(errorState: Bool, errorMessage: String?)
        case mobileNumberTextField(errorState: Bool, errorMessage: String?)
        case showAlert(alert: AlertViewModel)
        case showActivityIndicator(show: Bool)
        case updateMobileCode(code: String)
        case updateMobilePlaceholder(placeholder: String, length: Int)
        case updateCountry(countryName: String)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

extension AddBeneficiaryViewModel {
    private func validateRequiredFields() {
        if name?.isBlank ?? true || cnic?.isBlank ?? true || mobileNumber?.isBlank ?? true {
            output?(.addButtonState(enableState: false))
        } else {
            output?(.addButtonState(enableState: true))
        }
    }

    private func validateDataWithRegex() -> Bool {
        var isValid: Bool = true

        if name?.isValid(for: RegexConstants.nameRegex) ?? false {
            output?(.nameTextField(errorState: false, errorMessage: nil))
        } else {
            output?(.nameTextField(errorState: true, errorMessage: StringConstants.ErrorString.nameError.localized))
            isValid = false
        }

        if cnic?.isValid(for: RegexConstants.cnicRegex) ?? false {
            output?(.cnicTextField(errorState: false, errorMessage: nil))
        } else {
            output?(.cnicTextField(errorState: true, errorMessage: StringConstants.ErrorString.cnicError.localized))
            isValid = false
        }

        if country != nil && mobileNumber?.count ?? 0 == country?.length && mobileNumber?.isValid(for: RegexConstants.mobileNumberRegex) ?? false {
            output?(.mobileNumberTextField(errorState: false, errorMessage: nil))
        } else {
            output?(.mobileNumberTextField(errorState: true, errorMessage: StringConstants.ErrorString.mobileNumberError.localized))
            isValid = false
        }

        return isValid
    }
}

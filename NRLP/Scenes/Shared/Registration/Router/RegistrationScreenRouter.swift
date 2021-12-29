//
//  RegistrationScreenRouter.swift
//  1Link-NRLP
//
//  Created by VenD on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class RegistrationRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToBeneficiaryVerificationScreen(model: RegisterRequestModel) {
        self.navigationController?.pushViewController(BeneficiaryVerificationModuleBuilder().build(with: self.navigationController, model: model), animated: true)
    }

    func navigateToRemitterVerificationScreen(model: RegisterRequestModel) {
        self.navigationController?.pushViewController(RemitterVerificationModuleBuilder().build(with: self.navigationController, model: model), animated: true)
    }

    func navigateToCountryPicker(with onSelectionCountry: @escaping OnCountrySelectionCallBack, accountType: AccountType?) {
        self.navigationController?.pushViewController(CountryListModuleBuilder().build(with: self.navigationController, onCountrySelection: onSelectionCountry, userType: accountType), animated: true)
    }
    
    func navigateToCityPicker(with onSelectionCity: @escaping OnCitySelectionCallBack) {
        self.navigationController?.pushViewController(CityListModuleBuilder().build(with: self.navigationController, onCitySelection: onSelectionCity), animated: true)
    }
    
    func navigateToOTPScreen(model: RegisterRequestModel) {
        let nextVC = OTPModuleBuilder().build(with: self.navigationController, model: model)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func navigateToBeneficiaryFormScreen(model: RegisterRequestModel) {
        self.navigationController?.pushViewController(BeneficiaryFormBuilder().build(with: self.navigationController, model: model), animated: true)
    }
}

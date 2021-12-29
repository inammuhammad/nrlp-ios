//
//  BeneficiaryFormRouter.swift
//  NRLP
//
//  Created by Bilal Iqbal on 23/12/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class BeneficiaryFormRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToTermsAndConditionScreen(registerModel: RegisterRequestModel) {
        self.navigationController?.pushViewController(TermsAndConditionsModuleBuilder().build(with: self.navigationController, model: registerModel), animated: true)
    }

    func navigateToCountryPicker(with onSelectionCountry: @escaping OnCountrySelectionCallBack, accountType: AccountType?) {
        self.navigationController?.pushViewController(CountryListModuleBuilder().build(with: self.navigationController, onCountrySelection: onSelectionCountry, userType: accountType), animated: true)
    }
    
    func navigateToCityPicker(with onSelectionCity: @escaping OnCitySelectionCallBack) {
        self.navigationController?.pushViewController(CityListModuleBuilder().build(with: self.navigationController, onCitySelection: onSelectionCity), animated: true)
    }
}

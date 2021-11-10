//
//  AddBeneficiaryRouter.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class AddBeneficiaryRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func popToPreviousScreen() {
        self.navigationController?.popViewController(animated: true)
    }

    func navigateToCountryPicker(with onSelectionCountry: @escaping OnCountrySelectionCallBack, accountType: AccountType?) {
        self.navigationController?.pushViewController(CountryListModuleBuilder().build(with: self.navigationController, hideProgressBar: true, onCountrySelection: onSelectionCountry, userType: accountType), animated: true)
    }
}

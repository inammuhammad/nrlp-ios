//
//  ReceiverFormRouter.swift
//  NRLP
//
//  Created by Bilal Iqbal on 21/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ReceiverFormRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToCountryPicker(with onSelectionCountry: @escaping OnCountrySelectionCallBack, accountType: AccountType?) {
        self.navigationController?.pushViewController(CountryListModuleBuilder().build(with: self.navigationController, onCountrySelection: onSelectionCountry, userType: accountType), animated: true)
    }
    
    func navigateToCityPicker(with onSelectionCity: @escaping OnCitySelectionCallBack) {
        self.navigationController?.pushViewController(CityListModuleBuilder().build(with: self.navigationController, onCitySelection: onSelectionCity), animated: true)
    }

    func navigateToSuccessScreen(model: AddReceiverRequestModel) {
        self.navigationController?.pushViewController(ReceiverSuccessBuilder().build(with: self.navigationController, model: model), animated: true)
    }
}

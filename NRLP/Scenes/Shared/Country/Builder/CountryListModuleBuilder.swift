//
//  CountryListModuleBuilder.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class CountryListModuleBuilder {

    func build(with navigationController: UINavigationController?, hideProgressBar: Bool = false, onCountrySelection: @escaping OnCountrySelectionCallBack, userType: AccountType?) -> UIViewController {

        let viewController = CountryListViewController.getInstance()
        
        let coordinator = CountryListRouter(navigationController: navigationController)
        let viewModel = CountryListViewModel(with: CountryService(), router: coordinator, hideProgressBar: hideProgressBar, userType: userType)

        viewController.viewModel = viewModel
        viewController.onCountrySelection = onCountrySelection

        return viewController
    }
}

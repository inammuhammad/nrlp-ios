//
//  CityListModuleBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 28/12/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class CityListModuleBuilder {

    func build(with navigationController: UINavigationController?, hideProgressBar: Bool = false, onCitySelection: @escaping OnCitySelectionCallBack) -> UIViewController {

        let viewController = CityListViewController.getInstance()
        
        let coordinator = CityListRouter(navigationController: navigationController)
        let viewModel = CityListViewModel(with: CityService(), router: coordinator)

        viewController.viewModel = viewModel
        viewController.onCitySelection = onCitySelection

        return viewController
    }
}

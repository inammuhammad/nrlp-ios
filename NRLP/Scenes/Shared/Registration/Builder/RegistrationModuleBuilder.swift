//
//  RegistrationModuleBuilder.swift
//  1Link-NRLP
//
//  Created by VenD on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class RegistrationModuleBuilder {

    func build(with navigationController: UINavigationController?) -> UIViewController {

        let viewController = RegistrationViewController.getInstance()

        let coordinator = RegistrationRouter(navigationController: navigationController)
        let viewModel = RegistrationViewModel(router: coordinator)

        viewController.viewModel = viewModel

        return viewController
    }
}

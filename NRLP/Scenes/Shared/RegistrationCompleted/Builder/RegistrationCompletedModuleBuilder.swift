//
//  RegistrationCompletedModuleBuilder.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class RegistrationCompletedModuleBuilder {

    func build(with navigationController: UINavigationController?, accountType: AccountType) -> UIViewController {

        let viewController = OperationCompletedViewController.getInstance()

        let coordinator = RegistrationCompletedRouter(navigationController: navigationController)
        let viewModel = RegistrationCompletedViewModel(with: coordinator, accountType: accountType)

        viewController.viewModel = viewModel

        return viewController
    }
}

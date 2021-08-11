//
//  ForgotPassworsSuccessBuilder.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ForgotPasswordSuccessBuilder {

    func build(with navigationController: UINavigationController?) -> UIViewController {

        let viewController = OperationCompletedViewController.getInstance()

        let coordinator = ForgotPasswordSuccessRouter(navigationController: navigationController)
        let viewModel = ForgotPasswordSuccessViewModel(with: coordinator)

        viewController.viewModel = viewModel

        return viewController
    }
}

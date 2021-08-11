//
//  ForgotPasswordBuilder.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 14/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ForgotPasswordBuilder {

    func build(navigationController: UINavigationController?) -> UIViewController {

        let viewController = ForgotPasswordViewController.getInstance()

        let coordinator = ForgotPasswordRouter(navigationController: navigationController)
        let viewModel = ForgotPasswordViewModel(router: coordinator, service: ForgotPasswordService())
        viewController.viewModel = viewModel

        return viewController
    }
}

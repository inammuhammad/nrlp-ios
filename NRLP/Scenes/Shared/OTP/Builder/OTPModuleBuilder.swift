//
//  OTPModuleBuilder.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class OTPModuleBuilder {

    func build(with navigationController: UINavigationController?, model: RegisterRequestModel) -> UIViewController {

        let viewController = OTPViewController.getInstance()

        let coordinator = OTPRouter(navigationController: navigationController)
        let viewModel = OTPViewModel(with: coordinator, model: model, service: OTPService())

        viewController.viewModel = viewModel

        return viewController
    }
}

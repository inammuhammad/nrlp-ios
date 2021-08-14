//
//  ChangePasswordBuilder.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 16/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ChangePasswordBuilder {

    func build(with navigationController: UINavigationController?) -> UIViewController {

        let viewController = ChangePasswordViewController.getInstance()

        let coordinator = ChangePasswordRouter(navigationController: navigationController)
        let viewModel = ChangePasswordViewModel(router: coordinator, service: ChangePasswordService())

        viewController.viewModel = viewModel

        return viewController
    }
}

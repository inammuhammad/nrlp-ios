//
//  ChangePasswordSuccessBuilder.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 22/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ChangePasswordSuccessBuilder {

    func build(with navigationController: UINavigationController?) -> UIViewController {

        let viewController = OperationCompletedViewController.getInstance()

        let coordinator = ChangePasswordSuccessRouter(navigationController: navigationController)
        let viewModel = ChangePasswordSuccessViewModel(with: coordinator)

        viewController.viewModel = viewModel

        return viewController
    }
}

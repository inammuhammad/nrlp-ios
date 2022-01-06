//
//  NadraVerificationCompletedBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 04/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class NadraVerificationCompletedBuilder {

    func build(with navigationController: UINavigationController?, userModel: UserModel) -> UIViewController {

        let viewController = OperationCompletedViewController.getInstance()

        let coordinator = NadraVerificationCompletedRouter(navigationController: navigationController)
        let viewModel = NadraVerificationCompletedViewModel(with: coordinator, userModel: userModel)

        viewController.viewModel = viewModel

        return viewController
    }
}

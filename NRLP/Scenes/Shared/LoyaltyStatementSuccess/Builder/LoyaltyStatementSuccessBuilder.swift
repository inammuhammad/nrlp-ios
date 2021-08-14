//
//  LoyaltyStatementSuccessBuilder.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 21/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class LoyaltyStatementSuccessBuilder {

    func build(with navigationController: UINavigationController?) -> UIViewController {

        let viewController = OperationCompletedViewController.getInstance()

        let coordinator = LoyaltyStatementSuccessRouter(navigationController: navigationController)
        let viewModel = LoyaltyStatementSuccessViewModel(with: coordinator)

        viewController.viewModel = viewModel

        return viewController
    }
}

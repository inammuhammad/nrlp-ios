//
//  LoyaltyPointsBuilder.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 15/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class LoyaltyPointsBuilder {

    func build(with navigationController: UINavigationController?, userModel: UserModel) -> UIViewController {

        let viewController = LoyaltyPointsViewController.getInstance()

        let router = LoyaltyPointsRouter(navigationController: navigationController)
        let viewModel = LoyaltyPointsViewModel(router: router, userModel: userModel, service: LoyaltyPointsService())

        viewController.viewModel = viewModel

        return viewController
    }
}

//
//  RedeemSuccessBuilder.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class RedeemSuccessBuilder {

    func build(with navigationController: UINavigationController?, transactionId: String, partner: Partner) -> UIViewController {

        let viewController = OperationCompletedViewController.getInstance()

        let coordinator = RedeemSuccessRouter(navigationController: navigationController)
        let viewModel = RedeemSuccessViewModel(with: coordinator, transactionId: transactionId, partner: partner)

        viewController.viewModel = viewModel
        return viewController
    }
}

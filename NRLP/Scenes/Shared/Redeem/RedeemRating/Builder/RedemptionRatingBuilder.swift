//
//  RedemptionRatingBuilder.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 13/04/2022.
//

import UIKit

class RedemptionRatingBuilder {
    func build(with navigationController: UINavigationController?, transactionId: String) -> UIViewController {
  
        let viewController = RedemptionRatingViewController.getInstance()
        let coordinator = RedemptionRatingRouter(navigationController: navigationController)
        let viewModel = RedemptionRatingViewModel(router: coordinator, transactionId: transactionId, service: RedeemService())

        viewController.viewModel = viewModel

        return viewController
    }
}

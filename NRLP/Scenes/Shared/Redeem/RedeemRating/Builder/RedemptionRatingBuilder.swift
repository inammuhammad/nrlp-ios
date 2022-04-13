//
//  RedemptionRatingBuilder.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 13/04/2022.
//

import UIKit

class RedemptionRatingBuilder {
    func build(with navigationController: UINavigationController?) -> UIViewController {
        // TODO: Implementation
  
        let viewController = RedemptionRatingViewController.getInstance()
        let coordinator = RedemptionRatingRouter(navigationController: navigationController)
        let viewModel = RedemptionRatingViewModel(router: coordinator)

        viewController.viewModel = viewModel

        return viewController
    }
}

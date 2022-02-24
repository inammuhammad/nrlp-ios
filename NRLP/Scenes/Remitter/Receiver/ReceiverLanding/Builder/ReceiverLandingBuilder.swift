//
//  ReceiverLandingBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 18/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ReceiverLandingBuilder {

    func build(with navigationController: UINavigationController?) -> UIViewController {

        let viewController = ReceiverLandingViewController.getInstance()

        let coordinator = ReceiverLandingRouter(navigationController: navigationController)
        let viewModel = ReceiverLandingViewModel(router: coordinator)

        viewController.viewModel = viewModel

        return viewController
    }
}

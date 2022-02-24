//
//  ReceiverListingBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 22/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ReceiverListingBuilder {

    func build(with navigationController: UINavigationController?) -> UIViewController {

        let viewController = ReceiverListingViewController.getInstance()

        let coordinator = ReceiverListingRouter(navigationController: navigationController)
        let viewModel = ReceiverListingViewModel(with: coordinator)

        viewController.viewModel = viewModel

        return viewController
    }
}

//
//  ReceiverTypeBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 18/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ReceiverTypeBuilder {

    func build(with navigationController: UINavigationController?) -> UIViewController {

        let viewController = ReceiverTypeViewController.getInstance()

        let coordinator = ReceiverTypeRouter(navigationController: navigationController)
        let viewModel = ReceiverTypeViewModel(router: coordinator)

        viewController.viewModel = viewModel

        return viewController
    }
}

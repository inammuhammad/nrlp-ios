//
//  ReceiverDetailsBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 22/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ReceiverDetailsBuilder {

    func build(with navigationController: UINavigationController?, receiverModel: ReceiverModel) -> UIViewController {

        let viewController = ReceiverDetailsViewController.getInstance()

        let coordinator = ReceiverDetailsRouter(navigationController: navigationController)
        let viewModel = ReceiverDetailsViewModel(router: coordinator, model: receiverModel)

        viewController.viewModel = viewModel

        return viewController
    }
}

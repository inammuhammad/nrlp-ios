//
//  ReceiverSuccessBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 21/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ReceiverSuccessBuilder {

    func build(with navigationController: UINavigationController?, model: AddReceiverRequestModel) -> UIViewController {

        let viewController = ReceiverSuccessViewController.getInstance()

        let coordinator = ReceiverSuccessRouter(navigationController: navigationController)
        let viewModel = ReceiverSuccessViewModel(router: coordinator, model: model)

        viewController.viewModel = viewModel

        return viewController
    }
}

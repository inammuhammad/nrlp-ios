//
//  ReceiverFormBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 21/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ReceiverFormBuilder {

    func build(with navigationController: UINavigationController?, receiverType: RemitterReceiverType) -> UIViewController {

        let viewController = ReceiverFormViewController.getInstance()

        let coordinator = ReceiverFormRouter(navigationController: navigationController)
        let viewModel = ReceiverFormViewModel(router: coordinator, receiverType: receiverType)

        viewController.viewModel = viewModel

        return viewController
    }
}

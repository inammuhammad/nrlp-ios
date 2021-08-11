//
//  UUIDChangeBuilder.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class UUIDChangeBuilder {

    func build(with navigationController: UINavigationController?, model: LoginRequestModel) -> UIViewController {

        let viewController = UUIDChangeViewController.getInstance()

        let coordinator = UUIDChangeRouter(navigationController: navigationController)
        let viewModel = UUIDChangeViewModel(with: coordinator, model: model, service: LoginService())

        viewController.viewModel = viewModel

        return viewController
    }
}

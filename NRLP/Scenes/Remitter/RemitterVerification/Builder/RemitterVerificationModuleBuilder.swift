//
//  RemitterVerificationModuleBuilder.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class RemitterVerificationModuleBuilder {

    func build(with navigationController: UINavigationController?, model: RegisterRequestModel) -> UIViewController {

        let viewController = RemitterVerificationViewController.getInstance()

        let coordinator = RemitterVerificationRouter(navigationController: navigationController)
        let viewModel = RemitterVerificationViewModel(service: RemitterVerificationService(), router: coordinator, model: model)

        viewController.viewModel = viewModel

        return viewController
    }
}

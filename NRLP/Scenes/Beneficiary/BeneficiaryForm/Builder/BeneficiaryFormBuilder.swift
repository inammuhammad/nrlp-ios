//
//  BeneficiaryFormBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 23/12/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class BeneficiaryFormBuilder {

    func build(with navigationController: UINavigationController?, model: RegisterRequestModel) -> UIViewController {

        let viewController = BeneficiaryFormViewController.getInstance()

        let coordinator = BeneficiaryFormRouter(navigationController: navigationController)
        let viewModel = BeneficiaryFormViewModel(model: model, router: coordinator)

        viewController.viewModel = viewModel

        return viewController
    }
}

//
//  BeneficiaryVerificationModuleBuilder.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class BeneficiaryVerificationModuleBuilder {

    func build(with navigationController: UINavigationController?, model: RegisterRequestModel) -> UIViewController {

        let viewController = BeneficiaryVerificationViewController.getInstance()

        let coordinator = BeneficiaryVerificationRouter(navigationController: navigationController)
        let viewModel = BeneficiaryVerificationViewModel(service: APIKeyServiceDecorator(decoratee: BeneficiaryVerificationService(), appKeyService: AppKeyService()), router: coordinator, model: model)

        viewController.viewModel = viewModel

        return viewController
    }
}

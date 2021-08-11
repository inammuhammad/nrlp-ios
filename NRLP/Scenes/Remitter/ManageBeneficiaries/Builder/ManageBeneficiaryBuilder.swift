//
//  ManageBeneficiaryBuilder.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ManageBeneficiaryModuleBuilder {

    func build(with navigationController: UINavigationController?, user: UserModel) -> UIViewController {

        let viewController = ManageBeneficiariesViewController.getInstance()

        let coordinator = ManageBeneficiaryRouter(navigationController: navigationController)
        let viewModel = ManageBeneficiaryViewModel(with: ManageBeneficiaryService(), router: coordinator, user: user)

        viewController.viewModel = viewModel

        return viewController
    }
}

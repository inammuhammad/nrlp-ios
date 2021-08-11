//
//  AddBeneficiaryBuilder.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class AddBeneficiaryBuilder {

    func build(with navigationController: UINavigationController?) -> UIViewController {

        let viewController = AddBeneficiaryViewController.getInstance()

        let coordinator = AddBeneficiaryRouter(navigationController: navigationController)
        let viewModel = AddBeneficiaryViewModel(router: coordinator, service: ManageBeneficiaryService())

        viewController.viewModel = viewModel

        return viewController
    }
}

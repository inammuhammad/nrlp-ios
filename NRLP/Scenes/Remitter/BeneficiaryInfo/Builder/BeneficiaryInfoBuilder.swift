//
//  BeneficiaryInfoBuilder.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class BeneficiaryInfoModuleBuilder {

    func build(with navigationController: UINavigationController?, beneficiary: BeneficiaryModel, service: ManageBeneficiaryServiceProtocol) -> UIViewController {

        let viewController = BeneficiaryInfoViewController.getInstance()

        let coordinator = BeneficiaryInfoRouter(navigationController: navigationController)
        let viewModel = BeneficiaryInfoViewModel(router: coordinator, beneficiary: beneficiary, service: service)

        viewController.viewModel = viewModel

        return viewController
    }
}

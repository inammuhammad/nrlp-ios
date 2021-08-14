//
//  TransferBuilder.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 14/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class TransferSuccessModuleBuilder {

    func build(with navigationController: UINavigationController?, points: String, beneficiary: BeneficiaryModel) -> UIViewController {

        let viewController = OperationCompletedViewController.getInstance()

        let coordinator = TransferSuccessRouter(navigationController: navigationController)
        let viewModel = TransferSuccessViewModel(with: coordinator, points: points, beneficiary: beneficiary)

        viewController.viewModel = viewModel

        return viewController
    }
}

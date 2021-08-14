//
//  TransferPointsBuilder.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 14/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class TransferPointsBuilder {

    func build(with navigationController: UINavigationController?, user: UserModel) -> UIViewController {

        let viewController = TransferPointsViewController.getInstance()

        let coordinator = TransferPointsRouter(navigationController: navigationController)
        let viewModel = TransferPointsViewModel(with: coordinator, user: user, service: ManageBeneficiaryService())

        viewController.viewModel = viewModel

        return viewController
    }
}

//
//  RedemptionOTPBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 24/09/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class RedemptionOTPBuilder {

    func build(with navigationController: UINavigationController?, transactionId: String, partner: Partner, user: UserModel, inputModel: InitRedemptionTransactionModel, flowType: RedemptionFlowType) -> UIViewController {

        let viewController = RedemptionOTPViewController.getInstance()

        let coordinator = RedemptionOTPRouter(navigationController: navigationController)
        let viewModel = RedemptionOTPViewModel(with: coordinator,
                                           transactionId: transactionId,
                                           partner: partner,
                                           service: RedemptionService(),
                                           user: user, inputModel: inputModel, flowType: flowType)

        viewController.viewModel = viewModel

        return viewController
    }
}

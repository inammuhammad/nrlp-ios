//
//  RedemptionPSIDRouter.swift
//  NRLP
//
//  Created by Bilal Iqbal on 09/09/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class RedemptionPSIDRouter {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToOTPScreen(transactionID: String, partner: Partner, user: UserModel, inputModel: InitRedemptionTransactionModel, flowType: RedemptionFlowType) {
        let vc = RedemptionOTPBuilder().build(with: self.navigationController, transactionId: transactionID, partner: partner, user: user, inputModel: inputModel, flowType: flowType)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateBack() {
        if let navController = self.navigationController {
            let viewControllers: [UIViewController] = navController.viewControllers as [UIViewController]
            navController.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }
    }
    
}

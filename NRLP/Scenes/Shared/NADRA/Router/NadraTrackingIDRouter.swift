//
//  NadraTrackingIDRouter.swift
//  NRLP
//
//  Created by Bilal Iqbal on 21/09/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class NadraTrackingIDRouter {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToSuccessScreen(trackingID: String, amount: String, flowType: RedemptionFlowType) {
        if let nav = self.navigationController {
            let vc = OperationCompletedViewController.getInstance()
            let message = getSuccessMessage(trackingID: trackingID, amount: amount, flowType: flowType)
            vc.viewModel = RedemptionPSIDSuccessViewModel(with: nav, message: message)
            nav.pushViewController(vc, animated: true)
            
        }
    }
    
    func navigateBack() {
        if let navController = self.navigationController {
            let viewControllers: [UIViewController] = navController.viewControllers as [UIViewController]
            navController.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }
    }
    
    private func getSuccessMessage(trackingID: String, amount: String, flowType: RedemptionFlowType) -> String {
        return "You have redeemed \(amount) Points against\nTracking ID: \(trackingID) successfully at NADRA".localized
    }
}

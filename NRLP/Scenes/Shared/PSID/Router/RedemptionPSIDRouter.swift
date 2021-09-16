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
    
    func navigateToSuccessScreen(psid: String, amount: String, flowType: RedemptionFlowType) {
        print("NAVIGATE TO PSID")
//        self.navigationController?.pushViewController(, animated: true)
        if let nav = self.navigationController {
            let vc = OperationCompletedViewController.getInstance()
            let message = getSuccessMessage(psid: psid, amount: amount, flowType: flowType)
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
    
    private func getSuccessMessage(psid: String, amount: String, flowType: RedemptionFlowType) -> String {
        switch flowType {
        case .FBR:
            return "You have redeemed \(amount) Points against\nPSID \(psid) successfully at FBR"
        case .PIA:
            return "You have redeemed \(amount) Points against\nPSID \(psid) successfully at PIA"
        }
    }
}

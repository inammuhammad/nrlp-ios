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
    
    func navigateToSuccessScreen(psid: String) {
        print("NAVIGATE TO PSID")
//        self.navigationController?.pushViewController(, animated: true)
        if let nav = self.navigationController {
            let vc = OperationCompletedViewController.getInstance()
            vc.viewModel = RedemptionPSIDSuccessViewModel(with: nav, message: "You have redeemed 5,900 Points against\nPSID \(psid) successfully at FBR")
            nav.pushViewController(vc, animated: true)
            
        }
    }
    
    func navigateBack() {
        if let navController = self.navigationController {
            let viewControllers: [UIViewController] = navController.viewControllers as [UIViewController]
            navController.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }
    }
}

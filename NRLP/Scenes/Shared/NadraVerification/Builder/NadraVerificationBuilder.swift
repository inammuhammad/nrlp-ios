//
//  NadraVerificationBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 03/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class NadraVerificationBuilder {
    
    func build(userModel: UserModel) -> UIViewController {
        
        let viewController = NadraVerificationViewController.getInstance()
        let navigationController = BaseNavigationController(rootViewController: viewController)
        navigationController.hideShadow()
        let coordinator = NadraVerificationRouter(navigationController: navigationController)
        let viewModel = NadraVerificationViewModel(router: coordinator, userModel: userModel)
        viewController.viewModel = viewModel
        
        return navigationController
    }
}

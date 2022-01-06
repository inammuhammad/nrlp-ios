//
//  NadraVerificationFormBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 04/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class NadraVerificationFormBuilder {
    func build(with navigationController: UINavigationController, userModel: UserModel) -> UIViewController {
        
        let viewController = NadraVerificationFormViewController.getInstance()
        let coordinator = NadraVerificationFormRouter(navigationController: navigationController)
        let viewModel = NadraVerificationFormViewModel(router: coordinator, userModel: userModel)
        viewController.viewModel = viewModel
        
        return viewController
    }
}

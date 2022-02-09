//
//  ProfileVerificationBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 08/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ProfileVerificationBuilder {

    func build(with navigationController: UINavigationController?, onMotherNameVerified: @escaping NadraVerifiedCallBack) -> UIViewController {

        let viewController = ProfileVerificationViewController.getInstance()
        
        let coordinator = ProfileVerificationRouter(navigationController: navigationController)
        let viewModel = ProfileVerificationViewModel(with: coordinator, isVerifiedCallBack: onMotherNameVerified)
        
        viewController.viewModel = viewModel

        return viewController
    }
}

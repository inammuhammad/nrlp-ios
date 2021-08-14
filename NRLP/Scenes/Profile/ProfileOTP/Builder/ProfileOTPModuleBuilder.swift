//
//  ProfileOTPModuleBuilder.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ProfileOTPModuleBuilder {

    func build(with navigationController: UINavigationController?, model: ProfileUpdateModel) -> UIViewController {

        let viewController = ProfileOTPViewController.getInstance()
        let coordinator = ProfileOTPRouter(navigationController: navigationController)
        let viewModel = ProfileOTPViewModel(with: coordinator, model: model, service: UserProfileService())
        viewController.viewModel = viewModel

        return viewController
    }
}

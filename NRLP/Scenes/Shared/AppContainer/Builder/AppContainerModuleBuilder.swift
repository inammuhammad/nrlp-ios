//
//  AppContainerModuleBuilder.swift
//  1Link-NRLP
//
//  Created by VenD on 15/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

import UIKit

class AppContainerModuleBuilder {

    func build(for user: UserModel) -> UIViewController {

        let containerViewController = AppContainerViewController()

        if let navigationViewController = HomeModuleBuilder().build(for: user) as? UINavigationController,
            let home = navigationViewController.topViewController as? HomeViewController {
            containerViewController.centerViewController = home
            containerViewController.centerNavigationController = navigationViewController
            containerViewController.viewModel = AppContainerViewModel(userModel: user)
        }

        return containerViewController
    }
}

//
//  LoginBuilder.swift
//  1Link-NRLP
//
//  Created by ajmal on 06/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class LoginModuleBuilder {

    func build() -> UIViewController {

        let viewController = LoginViewController.getInstance()

        let navigationController = BaseNavigationController(rootViewController: viewController)
        navigationController.hideShadow()
        let coordinator = LoginRouter(navigationController: navigationController)
        let service = APIKeyServiceDecorator<LoginServiceProtocol>(decoratee: LoginService(), appKeyService: AppKeyService())
        let viewModel = LoginViewModel(service: service, router: coordinator)

        viewController.viewModel = viewModel
        
        AESConfigs.currentConfiguration = .normal

        return navigationController
    }
}

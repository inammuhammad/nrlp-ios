//
//  HomeModuleBuilder.swift
//  1Link-NRLP
//
//  Created by VenD on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class HomeModuleBuilder {

    func build(for user: UserModel) -> UIViewController {

        let viewController = HomeViewController.getInstance()

        let navigationController = BaseNavigationController(rootViewController: viewController)
        navigationController.showShadow()
        let coordinator = HomeRouter(navigationController: navigationController)

        viewController.viewModel = getHomeViewModel(for: user, coordinator: coordinator)

        return navigationController
    }

    private func getHomeViewModel(for user: UserModel, coordinator: HomeRouter) -> HomeViewModelProtocol? {

        let viewModel: HomeViewModel?
        switch user.accountType {
        case .beneficiary:
            viewModel = BeneficiaryHomeViewModel(with: user, router: coordinator)
        case .remitter:
            viewModel = RemitterHomeViewModel(with: user, router: coordinator)
        case .none:
            viewModel = nil
        }

        return viewModel
    }
}

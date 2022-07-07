//
//  BanksAndExchangeBuilder.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 07/07/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

class BanksAndExchangeBuilder {
    func build(with navigationController: UINavigationController?, hideProgressBar: Bool = false, onBranchSelection: @escaping OnBranchSelectionCallBack, pseName: String) -> UIViewController {

        let viewController = BanksAndExchangeViewController.getInstance()

        let coordinator = BranchListRouter(navigationController: navigationController)
        let viewModel = BranchListViewModel(router: coordinator, hideProgressBar: hideProgressBar, pseName: pseName)

        viewController.viewModel = viewModel
        viewController.onBranchSelection = onBranchSelection

        return viewController
    }
}

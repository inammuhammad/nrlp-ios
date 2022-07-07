//
//  BanksAndExchangeBuilder.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 07/07/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

class BanksAndExchangeBuilder {
    func build(with navigationController: UINavigationController?, hideProgressBar: Bool = false, onBanksAndExchangeSelection: @escaping OnBankAndExchangeSelectionCallBack) -> UIViewController {

        let viewController = BanksAndExchangeViewController.getInstance()

        let coordinator = BanksAndExchangeRouter(navigationController: navigationController)
        let viewModel = BanksAndExchangeViewModel(router: coordinator, hideProgressBar: hideProgressBar)

        viewController.viewModel = viewModel
        viewController.onBanksAndExchangeSelection = onBanksAndExchangeSelection

        return viewController
    }
}

//
//  BankListingBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 08/03/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class BankListingBuilder {

    func build(with navigationController: UINavigationController?, onBankSelection: @escaping OnBankSelectionCallBack) -> UIViewController {

        let viewController = BankListingViewController.getInstance()
        
        let coordinator = BankListingRouter(navigationController: navigationController)
        let viewModel = BankListingViewModel(with: BankListingService(), router: coordinator)

        viewController.viewModel = viewModel
        viewController.onBankSelection = onBankSelection

        return viewController
    }
}

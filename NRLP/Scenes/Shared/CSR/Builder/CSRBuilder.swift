//
//  CSRBuilder.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 09/06/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

class CSRBuilder {
    func build(with navigationController: UINavigationController?, model: CSRModel) -> UIViewController {
  
        let viewController = CSRViewController.getInstance()
        let coordinator = CSRRouter(navigationController: navigationController)
        let viewModel = CSRViewModel(router: coordinator, model: model)

        viewController.viewModel = viewModel

        return viewController
    }
}

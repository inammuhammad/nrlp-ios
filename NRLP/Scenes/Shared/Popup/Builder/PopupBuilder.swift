//
//  PopupBuilder.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 04/07/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class PopupBuilder {

    func build(with navigationController: UINavigationController?, model: PopupResponseModel) -> UIViewController {

        let viewController = PopupViewController.getInstance()
        
        let coordinator = PopupRouter(navigationController: navigationController)
        let viewModel = PopupViewModel(router: coordinator, model: model)

        viewController.viewModel = viewModel

        return viewController
    }
}

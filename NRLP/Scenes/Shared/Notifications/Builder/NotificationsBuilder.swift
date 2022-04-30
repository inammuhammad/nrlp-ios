//
//  NotificationsBuilder.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 30/04/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

class NotificationsBuilder {
    
    func build(with navigationController: UINavigationController?) -> UIViewController {

        let viewController = NotificationsViewController.getInstance()
        
//        let coordinator = NotificationsRouter(navigationController: navigationController)
        let viewModel = NotificationsViewModel(
//            with: BankListingService(),
//            router: coordinator
        )

        viewController.viewModel = viewModel
        
        return viewController
    }
}

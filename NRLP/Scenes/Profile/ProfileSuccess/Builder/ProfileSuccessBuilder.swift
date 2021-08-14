//
//  ProfileSuccessBuilder.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ProfileSuccessBuilder {

    func build(with navigationController: UINavigationController?) -> UIViewController {

        let storyboard = UIStoryboard(name: "OperationCompleted", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "OperationCompletedViewController") as! OperationCompletedViewController

        let coordinator = ProfileSuccessRouter(navigationController: navigationController)
        let viewModel = ProfileSuccessViewModel(with: coordinator)

        viewController.viewModel = viewModel
        return viewController
    }
}

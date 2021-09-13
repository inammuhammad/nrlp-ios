//
//  RedemptionPSIDBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 09/09/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class RedemptionPSIDBuilder {
    
    func build(with navigationController: UINavigationController?, model: UserModel) -> UIViewController {
        
        let viewController = RedemptionPSIDViewController.getInstance()
            
        let coordinator = RedemptionPSIDRouter(navigationController: navigationController)
        let viewModel = RedemptionPSIDViewModel(router: coordinator, user: model)
        viewController.viewModel = viewModel
        
        return viewController
    }
}

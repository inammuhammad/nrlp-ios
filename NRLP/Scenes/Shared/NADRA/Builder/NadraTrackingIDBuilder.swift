//
//  NadraTrackingIDBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 21/09/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class NadraTrackingIDBuilder {
    
    func build(with navigationController: UINavigationController?, model: UserModel, flowType: RedemptionFlowType) -> UIViewController {
        
        let viewController = NadraTrackingIDViewController.getInstance()
            
        let coordinator = NadraTrackingIDRouter(navigationController: navigationController)
        let viewModel = NadraTrackingIDViewModel(router: coordinator, user: model, flowType: flowType)
        viewController.viewModel = viewModel
        
        return viewController
    }
}

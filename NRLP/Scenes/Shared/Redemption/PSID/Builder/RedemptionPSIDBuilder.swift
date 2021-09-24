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
    
    func build(with navigationController: UINavigationController?, partner: Partner, model: UserModel, flowType: RedemptionFlowType) -> UIViewController {
        
        let viewController = RedemptionPSIDViewController.getInstance()
            
        let coordinator = RedemptionPSIDRouter(navigationController: navigationController)
        let viewModel = RedemptionPSIDViewModel(router: coordinator, partner: partner, user: model, flowType: flowType)
        viewController.viewModel = viewModel
        
        return viewController
    }
}

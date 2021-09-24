//
//  RedemptionFBRBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 09/09/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class RedemptionFBRBuilder {
    
    func build(with navigationController: UINavigationController?, partner: Partner, model: UserModel, flowType: RedemptionFlowType) -> UIViewController {
        
        let viewController = RedemptionFBRViewController.getInstance()
            
        let coordinator = RedemptionFBRRouter(navigationController: navigationController)
        let viewModel = RedemptionFBRViewModel(router: coordinator, partner: partner, user: model, flowType: flowType)
        viewController.viewModel = viewModel
        
        return viewController
    }
}

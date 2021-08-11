//
//  BenefitsBuilder.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 13/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit
import Foundation

class BenefitsBuilder {
    func build(with navigationController: UINavigationController?) -> UIViewController {
        
        let viewController = BenefitsViewController.getInstance()
        
        let coordinator = BenefitsRouter(navigationController: navigationController)
        let viewModel = BenefitsViewModel(router: coordinator)

        viewController.viewModel = viewModel
        
        return viewController
    }
    
}

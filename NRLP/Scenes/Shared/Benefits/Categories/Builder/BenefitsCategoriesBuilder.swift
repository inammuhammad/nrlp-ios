//
//  BenefitsCategoriesBuilder.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 14/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class BenefitsCategoriesBuilder {
    func build(with navigationController: UINavigationController?, partner: NRLPPartners) -> UIViewController {
        
        let viewController = BenefitsCategoriesViewController.getInstance()
        let coordinator = BenefitsCategoriesRouter(navigationController: navigationController)
        let viewModel = BenefitsCategoriesViewModel(router: coordinator, partner: partner)

        viewController.viewModel = viewModel
        
        return viewController
    }
}

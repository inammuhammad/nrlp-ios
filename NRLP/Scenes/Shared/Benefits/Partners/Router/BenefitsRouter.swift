//
//  BenefitsRouter.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 13/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit
import Foundation

class BenefitsRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToCategory(partner: NRLPPartners) {
        self.navigationController?.pushViewController(BenefitsCategoriesBuilder().build(with: self.navigationController, partner: partner), animated: true)
    }
}

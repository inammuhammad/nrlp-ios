//
//  TransferPointsRouter.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 14/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class TransferPointsRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToSuccessScreen(points: String, beneficiary: BeneficiaryModel) {
        self.navigationController?.pushViewController(TransferSuccessModuleBuilder().build(with: self.navigationController, points: points, beneficiary: beneficiary), animated: true)
    }
}

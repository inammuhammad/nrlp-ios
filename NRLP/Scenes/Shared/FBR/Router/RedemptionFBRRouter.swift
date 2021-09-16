//
//  RedemptionFBRRouter.swift
//  NRLP
//
//  Created by Bilal Iqbal on 09/09/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class RedemptionFBRRouter {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToPSIDScreen(user: UserModel, flowType: RedemptionFlowType) {
        print("NAVIGATE TO PSID")
        self.navigationController?.pushViewController(RedemptionPSIDBuilder().build(with: self.navigationController, model: user, flowType: flowType), animated: true)
    }
    
    func navigateBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

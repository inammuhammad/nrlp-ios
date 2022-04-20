//
//  RedemptionRatingRouter.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 13/04/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class RedemptionRatingRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

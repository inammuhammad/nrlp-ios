//
//  RedeemSuccessRouter.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class RedeemSuccessRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // FIXME: Remove
//    func navigateToRedemptionRating() {
//        self.navigationController?.pushViewController(
//            RedemptionRatingBuilder().build(with: self.navigationController),
//            animated: true
//        )
//    }
}

//
//  LoyaltyPointsRouter.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 15/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class LoyaltyPointsRouter {

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func moveToAdvanceStatement() {
        self.navigationController?.pushViewController(UIViewController(), animated: true)
    }

    func navigateToFilterScreen(userModel: UserModel) {
        self.navigationController?.pushViewController(GenerateStatementBuilder().build(with: navigationController!, userModel: userModel), animated: true)
    }
}

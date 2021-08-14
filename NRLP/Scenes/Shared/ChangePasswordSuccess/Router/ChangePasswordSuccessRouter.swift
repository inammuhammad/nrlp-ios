//
//  ChangePasswordSuccessRouter.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 22/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ChangePasswordSuccessRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func navigateToLoginScreen() {
        UIApplication.shared.keyWindow?.switchRoot(withRootController: LoginModuleBuilder().build())
    }
}

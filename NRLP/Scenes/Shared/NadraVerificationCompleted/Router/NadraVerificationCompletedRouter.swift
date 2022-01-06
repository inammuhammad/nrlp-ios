//
//  NadraVerificationCompletedRouter.swift
//  NRLP
//
//  Created by Bilal Iqbal on 04/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class NadraVerificationCompletedRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToHomeScreen(user: UserModel) {
        UIApplication.shared.keyWindow?.switchRoot(withRootController: AppContainerModuleBuilder().build(for: user))
    }
}

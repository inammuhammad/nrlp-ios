//
//  FatherNameRouter.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 05/06/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

class FatherNameRouter {
    func navigateToHomeScreen(userModel: UserModel) {
        UIApplication.shared.keyWindow?.switchRoot(withRootController: AppContainerModuleBuilder().build(for: userModel))
    }

    func navigateToLoginScreen() {
        UIApplication.shared.keyWindow?.switchRoot(withRootController: LoginModuleBuilder().build())
    }
}

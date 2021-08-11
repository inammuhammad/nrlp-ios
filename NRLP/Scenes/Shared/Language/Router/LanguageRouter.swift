//
//  LanguageRouter.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 10/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class LanguageRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func getRootNavigationItem() -> UIViewController? {
        navigationController?.viewControllers.first
    }
    
    func navigateToLoginView() {
        UIApplication.shared.keyWindow?.switchRoot(withRootController: LoginModuleBuilder().build())
    }
    
    func navigateToHomeView(for user: UserModel) {
        UIApplication.shared.keyWindow?.switchRoot(withRootController: AppContainerModuleBuilder().build(for: user))
    }
}

//
//  NadraVerificationRouter.swift
//  NRLP
//
//  Created by Bilal Iqbal on 03/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class NadraVerificationRouter {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToLoginScreen() {
        UIApplication.shared.keyWindow?.switchRoot(withRootController: LoginModuleBuilder().build())
    }
    
    func navigateToNadraVerificatonForm(userModel: UserModel){
        if let navVC = self.navigationController {
            self.navigationController?.pushViewController(NadraVerificationFormBuilder().build(with: navVC, userModel: userModel), animated: true)
        }
    }
    
}

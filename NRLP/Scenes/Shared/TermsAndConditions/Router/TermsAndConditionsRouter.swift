//
//  TermsAndConditionsRouter.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class TermsAndConditionRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToRegistrationCompletionScreen(accountType: AccountType) {
        self.navigationController?.pushViewController(RegistrationCompletedModuleBuilder().build(with: self.navigationController, accountType: accountType), animated: true)
    }

    func navigateToLoginScreen() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

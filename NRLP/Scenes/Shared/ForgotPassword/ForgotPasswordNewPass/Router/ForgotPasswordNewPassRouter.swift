//
//  ForgotPasswordNewPassRouter.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 15/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ForgotPasswordNewPassRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func navigateToSuccess() {
        let vc = ForgotPasswordSuccessBuilder().build(with: self.navigationController)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateBackToForgotPasswordScreen() {
        navigationController?.popBack(toControllerType: ForgotPasswordViewController.self)
    }
}

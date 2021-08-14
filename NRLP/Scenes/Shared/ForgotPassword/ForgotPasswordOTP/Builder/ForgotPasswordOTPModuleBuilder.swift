//
//  OTPModuleBuilder.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ForgotPasswordOTPBuilder {

    func build(with navigationController: UINavigationController?, forgotPasswordRequestModel: ForgotPasswordSendOTPRequest) -> UIViewController {

        let viewController = ForgotPasswordOTPViewController.getInstance()

        let coordinator = ForgotPasswordOTPRouter(navigationController: navigationController)
        let viewModel = ForgotPasswordOTPViewModel(with: coordinator, forgotPasswordRequestModel: forgotPasswordRequestModel, service: ForgotPasswordService())

        viewController.viewModel = viewModel

        return viewController
    }
}

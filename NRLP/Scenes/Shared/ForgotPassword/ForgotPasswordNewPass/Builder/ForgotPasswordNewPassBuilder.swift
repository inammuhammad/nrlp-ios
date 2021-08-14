//
//  ForgotPasswordNewPassBuilder.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 15/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ForgotPasswordNewPassBuilder {

    func build(navigationController: UINavigationController?, forgotPasswordRequestModel: ForgotPasswordSendOTPRequest) -> UIViewController {

        let viewController = ForgotPasswordNewPassViewController.getInstance()

        let coordinator = ForgotPasswordNewPassRouter(navigationController: navigationController)
        let viewModel = ForgotPasswordNewPassViewModel(router: coordinator, forgotPasswordRequestModel: forgotPasswordRequestModel, service: ForgotPasswordService())
        viewController.viewModel = viewModel

        return viewController
    }

}

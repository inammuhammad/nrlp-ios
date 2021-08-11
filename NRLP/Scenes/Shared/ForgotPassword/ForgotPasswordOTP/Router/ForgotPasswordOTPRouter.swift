//
//  OTPRouter.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ForgotPasswordOTPRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToNewPasswordScreen(forgotPasswordRequestModel: ForgotPasswordSendOTPRequest) {
        let vc = ForgotPasswordNewPassBuilder().build(navigationController: navigationController, forgotPasswordRequestModel: forgotPasswordRequestModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

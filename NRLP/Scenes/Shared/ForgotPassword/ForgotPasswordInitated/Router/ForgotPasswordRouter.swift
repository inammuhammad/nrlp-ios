//
//  ForgotPasswordRouter.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 14/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ForgotPasswordRouter {

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToOTPScreen(forgotPasswordRequestModel: ForgotPasswordSendOTPRequest) {
         let vc = ForgotPasswordOTPBuilder().build(with: navigationController, forgotPasswordRequestModel: forgotPasswordRequestModel)
         self.navigationController?.pushViewController(vc, animated: true)
     }
}

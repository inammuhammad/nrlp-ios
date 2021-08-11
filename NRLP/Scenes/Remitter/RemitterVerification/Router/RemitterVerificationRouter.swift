//
//  RemitterVerificationRouter.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class RemitterVerificationRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToNextScreen(model: RegisterRequestModel) {
           let nextVC = OTPModuleBuilder().build(with: self.navigationController, model: model)
           self.navigationController?.pushViewController(nextVC, animated: true)
       }
}

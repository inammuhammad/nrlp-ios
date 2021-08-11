//
//  BeneficiaryVerificationRouter.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class BeneficiaryVerificationRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToNextScreen(registerModel: RegisterRequestModel) {
        let nextVC = TermsAndConditionsModuleBuilder().build(with: self.navigationController, model: registerModel)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

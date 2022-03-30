//
//  TermsAndConditionsModuleBuilder.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class TermsAndConditionsModuleBuilder {

    func build(with navigationController: UINavigationController?, model: RegisterRequestModel, isFromBeneficiary: Bool = false) -> UIViewController {

        let viewController = TermsAndConditionsViewController.getInstance()

        let coordinator = TermsAndConditionRouter(navigationController: navigationController)
        let viewModel = TermsAndConditionViewModel(with: coordinator, model: model, termsAndConditionService: TermsAndConditionService(), registerUserService: RegisterUserService(), cancelRegisterUserService: CancelRegisterUserService(), isFromBeneficiary: isFromBeneficiary)
        viewController.viewModel = viewModel

        return viewController
    }
}

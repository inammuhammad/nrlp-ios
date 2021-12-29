//
//  LoginRouter.swift
//  1Link-NRLP
//
//  Created by ajmal on 06/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class LoginRouter {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToRegistrationScreen() {
        self.navigationController?.pushViewController(RegistrationModuleBuilder().build(with: navigationController), animated: true)
    }

    func navigateToHomeScreen(user: UserModel) {
        UIApplication.shared.keyWindow?.switchRoot(withRootController: AppContainerModuleBuilder().build(for: user))
    }

    func navigateToUUIDChangeScreen(model: LoginRequestModel) {
        self.navigationController?.pushViewController(UUIDChangeBuilder().build(with: navigationController, model: model), animated: true)
    }

    func navigateToForgotPassword() {
        self.navigationController?.pushViewController(ForgotPasswordBuilder().build(navigationController: navigationController), animated: true)
    }
    
    func navigateToAbout() {
        AppUtility.goToWebsite(url: AppConstants.aboutNRLPUrl) { (_) in }
    }
    
    func navigateToBenefits() {
        self.navigationController?.pushViewController(BenefitsBuilder().build(with: navigationController), animated: true)
    }
    
    func navigateToComplaints() {
        print("Navigate to complaints".uppercased())
//        self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
    }
}

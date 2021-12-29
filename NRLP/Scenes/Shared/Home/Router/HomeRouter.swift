//
//  HomeRouter.swift
//  1Link-NRLP
//
//  Created by VenD on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class HomeRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToLoyaltyScreen(user: UserModel) {
        self.navigationController?.pushViewController(RedeemModuleBuilder().build(with: self.navigationController, user: user), animated: true)
    }

    func navigateToManageBeneficiariesScreen(userModel: UserModel) {
        self.navigationController?.pushViewController(ManageBeneficiaryModuleBuilder().build(with: self.navigationController, user: userModel), animated: true)
    }

    func navigateToManagePointsScreen(userModel: UserModel) {
        let vc = TransferPointsBuilder().build(with: self.navigationController, user: userModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToViewStatement(userModel: UserModel) {
        let vc = LoyaltyPointsBuilder().build(with: self.navigationController, userModel: userModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToNRLPBenefits() {
        self.navigationController?.pushViewController(BenefitsBuilder().build(with: navigationController), animated: true)
    }
    
    func navigateToProfile() {
        let vc = ProfileBuilder().build(with: self.navigationController)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToChangePassword() {
        self.navigationController?.pushViewController(ChangePasswordBuilder().build(with: navigationController), animated: true)
    }

    func navigateToLoginScreen() {
        UIApplication.shared.keyWindow?.switchRoot(withRootController: LoginModuleBuilder().build())
    }
    
    func navigateToLanguageChange(user: UserModel) {
        self.navigationController?.pushViewController(LanguageBuilder().build(navigationController: navigationController, user: user), animated: true)
    }

    func navigateToFaqs() {
        self.navigationController?.pushViewController(FAQModuleBuilder().build(), animated: true)
    }
    
    func navigateToContactUs() {
        self.navigationController?.pushViewController(ContactUsBuilder().build(), animated: true)
    }

    func navigateToSelfAward(user: UserModel) {
        let viewController = SelfAwardViewController.getInstance()
        viewController.user = user
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigateToGuide(link: String, error: (String) -> Void) {
        AppUtility.goToYouTube(youtubeLink: link, onFailure: error)
    }
}

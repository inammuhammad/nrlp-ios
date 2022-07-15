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
//        let viewController = SelfAwardViewController.getInstance()
//        viewController.user = user
        self.navigationController?.pushViewController(
            SelfAwardBuilder().build(with: navigationController, userModel: user),
            animated: true
        )
    }
    
    func navigateToGuide(link: String, error: (String) -> Void) {
        AppUtility.goToYouTube(youtubeLink: link, onFailure: error)
    }
    
    func navigateToComplaintManagement(userType: AccountType, currentUser: UserModel) {
//        return ()
        self.navigationController?.pushViewController(ComplaintTypeBuilder().build(with: self.navigationController, userType: userType, loginState: .loggedIn, currentUser: currentUser), animated: true)
    }
    
    func navigateToNadraVerificationScreen(userModel: UserModel) {
        UIApplication.shared.keyWindow?.switchRoot(withRootController: NadraVerificationBuilder().build(userModel: userModel))
    }
    
    func navigateToRemitterReceiverManagement(showListing: Bool) {
        if showListing {
            self.navigationController?.pushViewController(ReceiverListingBuilder().build(with: navigationController), animated: true)
            return
        }
        self.navigationController?.pushViewController(ReceiverLandingBuilder().build(with: self.navigationController), animated: true)
    }
    
    func navigateToNotifications(cnicNicop: String) {
        self.navigationController?.pushViewController(NotificationsBuilder().build(with: self.navigationController, cnicNicop: cnicNicop), animated: true)
    }
    
    func navigateToFatherNameScreen(userModel: UserModel) {
        UIApplication.shared.keyWindow?.switchRoot(withRootController: FatherNameBuilder().build(userModel: userModel))
    }
    
    func navigateToPopupScreen(with message: String) {
        let vc = PopupBuilder().build(with: self.navigationController, message: message)
        vc.modalPresentationStyle = .currentContext
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(vc, animated: true)
    }
}

//
//  OperationCompletedViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 16/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

enum OperationCompletedType {
    case registrationCompleted(accountType: AccountType)
    case changePassword
    case forgetPassword
    case transferCompleted
    case loyaltyStatement
    case loyaltyRedeemCompleted
    case profileUpdateCompleted

    func getIllustrationName() -> String {
        switch self {
        case .registrationCompleted, .transferCompleted, .loyaltyRedeemCompleted, .forgetPassword, .changePassword, .profileUpdateCompleted, .loyaltyStatement:
            return "successIcon"
        }
    }

    func getTitle() -> String {
        switch self {
        case .registrationCompleted:
            return "Registration Successful".localized
        case .changePassword:
            return "Update Successful".localized
        case .profileUpdateCompleted:
            return "Update Profile".localized
        case .forgetPassword:
            return "Change Password Successful".localized
        case .transferCompleted:
            return "Points transferred Successfully".localized
        case .loyaltyStatement:
            return "View More Transactions".localized
        case .loyaltyRedeemCompleted:
            return "Redeemed Successfully".localized
        }
    }

    func getDescription() -> NSAttributedString {

        var result: String

        switch self {
        case .registrationCompleted(let accountType):
            switch accountType {
            case .beneficiary:
                result = "Thank you for registering. You can now enjoy exciting benefits and rewards!".localized
            case .remitter:
                result = "Thank you for registering. You can now earn loyalty points on your next remittance to Pakistan!".localized
            }
        case .changePassword:
            result = "You have successfully updated your password.".localized
        case .forgetPassword:
            result = "You have registered a New Password. Please go to the login screen and log in with your new password.".localized
        case .loyaltyStatement:
            result = "Your request for Statement has been generated. The statement will be emailed to you on the email address provided in 3 to 5 working days.".localized
        case .loyaltyRedeemCompleted:
            result = ""
        case .profileUpdateCompleted:
            result = "You have successfully updated your profile.".localized
        default:
            result = ""
        }

        return NSAttributedString(string: result, attributes: [
            NSAttributedString.Key.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ])
    }

    func getCTAButtonTitle() -> String {
        switch self {
        case .forgetPassword:
            return "Go to Login".localized
        case .transferCompleted, .registrationCompleted, .changePassword, .loyaltyRedeemCompleted, .profileUpdateCompleted, .loyaltyStatement:
            return "Done".localized
        }
    }
}

protocol OperationCompletedViewModelProtocol {
    var description: NSAttributedString { get }
    var title: String { get }
    var illustrationImageName: String { get }
    var ctaButtonTitle: String { get }
    func didTapCTAButton()
}

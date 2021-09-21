//
//  Initializable.swift
//  1Link-NRLP
//
//  Created by VenD on 10/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

import UIKit

protocol Initializable where Self: UIViewController {
    static var storyboardName: UIStoryboard.Name { get }
}

extension Initializable {
    
    private static var identifier: String {
        let name = String.init(describing: Self.self)
        return name
    }
    
    static func getInstance() -> Self {
        let storyboard = UIStoryboard(name: self.storyboardName.rawValue, bundle: Bundle.main)
        let instance = storyboard.instantiateViewController(withIdentifier: identifier)
        return instance as! Self
    }
}

extension UIStoryboard {
    enum Name: String {
        case alert = "Alert"
        case redeem = "Redeem"
        case redeemService = "RedeemService"
        case redeemOTP = "RedeemOTP"
        case redeemConfirm = "RedeemConfirm"
        case uuidChange = "UUIDChange"
        case faq = "FAQ"
        case forgotPassword = "ForgotPassword"
        case forgotPasswordOTP = "ForgotPasswordOTP"
        case forgotPasswordNewPass = "ForgotPasswordNewPass"
        case changePassword = "ChangePassword"
        case sideMenu = "SideMenu"
        case generateStatement = "GenerateStatement"
        case loyaltyPoints = "LoyaltyPoints"
        case operationCompleted = "OperationCompleted"
        case home = "Home"
        case termsAndConditions = "TermsAndConditions"
        case otp = "OTP"
        case countryList = "CountryList"
        case registration = "Registration"
        case login = "Login"
        case beneficiaryVerification = "BeneficiaryVerification"
        case transferPoints = "TransferPoints"
        case addBeneficiary = "AddBeneficiary"
        case beneficiaryInfo = "BeneficiaryInfo"
        case manageBeneficiaries = "ManageBeneficiaries"
        case remitterVerification = "RemitterVerification"
        case benefits = "Benefits"
        case benefitsCategories = "BenefitsCategories"
        case language = "Language"
        case contactUs = "ContactUs"
        case profile = "Profile"
        case profileOTP = "ProfileOTP"
        case selfAward = "SelfAward"
        case selfAwardOTP = "SelfAwardOTP"
        case redemptionFBR = "RedemptionFBR"
        case redemptionPSID = "RedemptionPSID"
        case nadraTrackingID = "NadraTrackingID"
    }
}

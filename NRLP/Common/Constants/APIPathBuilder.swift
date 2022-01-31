//
//  APIPathBuilder.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 14/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

//1. Define entire app endpoints and envirment
struct APIPathBuilder {
    
    let url: String
    private let endPoint: EndPoint
    
    init(baseURL: BaseURL = .enivironment(Environment(rawValue: AppConstants.environment) ?? .dev), endPoint: EndPoint) {
        self.url = baseURL.url + endPoint.rawValue
        self.endPoint = endPoint
    }
    
    var encryptionStatus: APIRequestHeader.HeaderTypes {
        switch endPoint {
        case .authAppKey:
            return .unencrypted
        case .countryCode, .termsAndCondition:
            return .openApis
        default:
            return .allEncrypted
        }
    }
    
    enum Environment: String {
        case production = "Prod"
        case staging = "Staging"
        case dev = "Dev"
        
        var value: String {
            switch self {
            case .production, .staging:
                let sign: [UInt8] =  [60, 17, 6, 29, 0, 123, 65, 75, 34, 31, 7, 74, 7, 6, 5, 31, 64, 48, 10, 31, 88, 25, 8, 74, 33, 61, 42, 14, 3, 11, 8, 91, 58, 23, 30, 29, 92]
                //[60, 17, 6, 29, 0, 123, 65, 75, 45, 29, 2, 20, 71, 23, 6, 2, 64, 35, 14, 93, 25, 7, 6, 9, 39, 61, 36, 77, 4, 23, 15, 4, 123]
                return Replacer().deformatString(string: sign)
                
            case .dev:
                let sign: [UInt8] = [60, 17, 6, 29, 0, 123, 65, 75, 48, 14, 0, 0, 11, 27, 17, 14, 30, 58, 75, 67, 26, 0, 13, 14, 96, 61, 42, 22, 68, 21, 8, 91, 33, 4, 6, 64, 66, 45, 7, 10, 40, 64, 0, 22, 5, 4, 70]
                return Replacer().deformatString(string: sign)
            }
        }
    }
    
    enum EndPoint {
        case countryCode
        case referenceNumber
        case verifyOTP
        case resendOTP
        case termsAndCondition
        case register
        case beneficiaryVerification
        case login
        case authAppKey
        case manageBeneficiary
        case deleteBeneficiary
        case addBeneficiary
        case profile
        case forgotPassword
        case forgotPasswordVerify
        case resetPassword
        case faqs
        case changePassword
        case transferPoints
        case loyaltyStatement
        case logout
        case uuid
        case redeemPartnerCategory
        case redeemInitialize
        case redeemVerifyOTP
        case resentRedeemOTP
        case redeemComplete
        case fileDownload
        case updateProfileSendOTP
        case updateProfileResendOTP
        case updateProfileVerifyOTP
        case nrlpBenefits
        case nrlpBenefit(partnerId: String)
        case resentForgotPasswordOTP
        case resentUUIDChangeOTP
        case selfAwardValidateTransaction
        case selfAwardVerifyOTP
        case initRedemptionTransaction
        case redemptionTransactionSendOTP
        case completeRedemptionTransaction
        case cities
        case verifyNadra
        case addBeneficiaryResendCode
        case updateBeneficiary
        case addComplaints
        
        var rawValue: String {
            switch self {
            case .countryCode:
                let sign: [UInt8] = [55, 10, 7, 3, 7, 51, 23, 73, 32, 0, 10, 1, 26]
                return Replacer().deformatString(string: sign)
            case .referenceNumber:
                let sign: [UInt8] = [34, 0, 0, 4, 21, 56, 67, 22, 38, 9, 11, 22, 12, 26, 10, 10, 67, 61, 10]
                return Replacer().deformatString(string: sign)
            case .verifyOTP:
                let sign: [UInt8] = [34, 0, 0, 4, 21, 56, 67, 11, 55, 31]
                return Replacer().deformatString(string: sign)
            case .resendOTP:
                let sign: [UInt8] = [38, 0, 1, 8, 29, 37, 67, 11, 55, 31]
                return Replacer().deformatString(string: sign)
            case .termsAndCondition:
                let sign: [UInt8] = [32, 0, 0, 0, 0, 108, 13, 11, 45, 11, 7, 16, 0, 27, 7, 28]
                return Replacer().deformatString(string: sign)
            case .register:
                let sign: [UInt8] = [38, 0, 21, 4, 0, 53, 11, 22]
                return Replacer().deformatString(string: sign)
            case .beneficiaryVerification:
                let sign: [UInt8] = [34, 0, 0, 4, 21, 56, 67, 22, 38, 8, 7, 23, 29, 6, 8, 27, 7, 60, 11, 95, 21, 6, 7, 0]
                return Replacer().deformatString(string: sign)
            case .login:
                let sign: [UInt8] = [56, 10, 21, 4, 29]
                return Replacer().deformatString(string: sign)
            case .authAppKey:
                let appKey: [UInt8] = [53, 21, 2, 64, 24, 36, 23]
                return Replacer().deformatString(string: appKey)
            case .manageBeneficiary:
                let sign: [UInt8] = [56, 12, 1, 25]
                return Replacer().deformatString(string: sign)
            case .deleteBeneficiary:
                let sign: [UInt8] = [48, 0, 30, 8, 7, 36]
                return Replacer().deformatString(string: sign)
            case .addBeneficiary:
                let sign: [UInt8] = [53, 1, 22]
                return Replacer().deformatString(string: sign)
            case .profile:
                let sign: [UInt8] = [36, 23, 29, 11, 26, 45, 11]
                return Replacer().deformatString(string: sign)
            case .forgotPassword:
                let sign: [UInt8] = [50, 10, 0, 10, 28, 53, 67, 20, 34, 28, 29, 19, 6, 6, 13]
                return Replacer().deformatString(string: sign)
            case .forgotPasswordVerify:
                let sign: [UInt8] = [34, 0, 0, 4, 21, 56, 67, 2, 44, 29, 9, 11, 29, 89, 25, 14, 29, 32, 18, 29, 4, 13, 78, 10, 58, 35]
                return Replacer().deformatString(string: sign)
            case .resetPassword:
                let sign: [UInt8] = [38, 0, 1, 8, 7, 108, 30, 5, 48, 28, 25, 11, 27, 16]
                return Replacer().deformatString(string: sign)
            case .faqs:
                let sign: [UInt8] = [51, 0, 6, 64, 21, 32, 31, 23]
                return Replacer().deformatString(string: sign)
            case .changePassword:
                let sign: [UInt8] = [55, 13, 19, 3, 20, 36, 67, 20, 34, 28, 29, 19, 6, 6, 13]
                return Replacer().deformatString(string: sign)
            case .transferPoints:
                let sign: [UInt8] = [32, 23, 19, 3, 0, 39, 11, 22, 110, 31, 1, 13, 7, 0, 26]
                return Replacer().deformatString(string: sign)
            case .logout:
                let sign: [UInt8] = [56, 10, 21, 2, 6, 53]
                return Replacer().deformatString(string: sign)
            case .uuid:
                let sign: [UInt8] = [33, 21, 22, 12, 7, 36, 67, 13, 39, 10, 0, 16, 0, 18, 0, 10, 28]
                return Replacer().deformatString(string: sign)
            case .loyaltyStatement:
                let sign: [UInt8] = [56, 10, 11, 12, 31, 53, 23, 73, 48, 27, 15, 16, 12, 25, 12, 1, 26]
                return Replacer().deformatString(string: sign)
            case .redeemPartnerCategory:
                let sign: [UInt8] = [36, 4, 0, 25, 29, 36, 28, 23, 110, 12, 15, 16, 12, 19, 6, 29, 7, 54, 22]
                return Replacer().deformatString(string: sign)
            case .redeemInitialize:
                let sign: [UInt8] = [61, 11, 27, 25, 26, 32, 2, 13, 57, 10, 67, 22, 12, 16, 12, 2, 30, 39, 12, 29, 24, 68, 23, 23, 47, 61, 60, 3, 9, 17, 10, 27, 58]
                return Replacer().deformatString(string: sign)
            case .redeemVerifyOTP:
                let sign: [UInt8] = [38, 0, 22, 8, 22, 44, 67, 16, 49, 14, 0, 23, 8, 23, 29, 6, 1, 61, 72, 4, 19, 27, 10, 3, 55, 126, 32, 22, 26]
                return Replacer().deformatString(string: sign)
            case .redeemComplete:
                let sign: [UInt8] = [55, 10, 31, 29, 31, 36, 26, 1, 110, 29, 11, 0, 12, 17, 4, 66, 26, 33, 4, 28, 5, 8, 0, 17, 39, 60, 33]
                return Replacer().deformatString(string: sign)
            case .fileDownload:
                return ""
            case .updateProfileSendOTP:
                let sign: [UInt8] = [33, 21, 22, 12, 7, 36, 67, 20, 49, 0, 8, 13, 5, 17, 68, 28, 11, 61, 1, 95, 25, 29, 19]
                return Replacer().deformatString(string: sign)
            case .updateProfileResendOTP:
                let sign: [UInt8] =  [33, 21, 22, 12, 7, 36, 67, 20, 49, 0, 8, 13, 5, 17, 68, 29, 11, 32, 0, 28, 18, 68, 12, 17, 62]
                return Replacer().deformatString(string: sign)
            case .nrlpBenefits:
                let sign: [UInt8] = [58, 23, 30, 29, 94, 35, 11, 10, 38, 9, 7, 16, 26]
                return Replacer().deformatString(string: sign)
            case .nrlpBenefit(let partnerId):
                let sign: [UInt8] = [58, 23, 30, 29, 94, 35, 11, 10, 38, 9, 7, 16, 70, 75, 25, 14, 28, 39, 11, 23, 4, 54, 10, 1, 115]
                return "\(Replacer().deformatString(string: sign))\(partnerId)"
            case .updateProfileVerifyOTP:
                let sign: [UInt8] = [33, 21, 22, 12, 7, 36, 67, 20, 49, 0, 8, 13, 5, 17, 68, 25, 11, 33, 12, 20, 15, 68, 12, 17, 62]
                return Replacer().deformatString(string: sign)
            case .resentForgotPasswordOTP:
                let sign: [UInt8] =  [38, 0, 1, 8, 29, 37, 67, 2, 44, 29, 9, 1, 29, 89, 25, 14, 29, 32, 18, 29, 4, 13, 78, 10, 58, 35]
                return Replacer().deformatString(string: sign)
            case .resentUUIDChangeOTP:
                let sign: [UInt8] =  [33, 21, 22, 12, 7, 36, 67, 13, 39, 10, 0, 16, 0, 18, 0, 10, 28, 126, 23, 23, 5, 12, 13, 1, 99, 60, 59, 18]
                return Replacer().deformatString(string: sign)
            case .resentRedeemOTP:
                let sign: [UInt8] =  [38, 0, 22, 8, 30, 49, 26, 13, 44, 1, 67, 16, 27, 21, 7, 28, 15, 48, 17, 27, 25, 7, 78, 23, 43, 32, 42, 12, 14, 72, 12, 0, 36]
                return Replacer().deformatString(string: sign)
            case .selfAwardValidateTransaction:
                let sign: [UInt8] = [39, 0, 30, 11, 94, 32, 25, 5, 49, 11, 67, 18, 8, 24, 0, 11, 15, 39, 0, 95, 2, 27, 2, 11, 61, 50, 44, 22, 3, 10, 13]
                return Replacer().deformatString(string: sign)
            case .selfAwardVerifyOTP:
                let sign: [UInt8] = [39, 0, 30, 11, 94, 32, 25, 5, 49, 11, 67, 18, 12, 6, 15, 6, 23, 126, 10, 6, 6]
                return Replacer().deformatString(string: sign)
            case .initRedemptionTransaction:
                let sign: [UInt8] = [61, 11, 27, 25, 26, 32, 2, 13, 57, 10, 67, 22, 12, 16, 12, 2, 30, 39, 12, 29, 24, 68, 23, 23, 47, 61, 60, 3, 9, 17, 10, 27, 58]
                return Replacer().deformatString(string: sign)
            case .redemptionTransactionSendOTP:
                let sign: [UInt8] = [61, 11, 27, 25, 26, 32, 2, 13, 57, 10, 67, 22, 12, 16, 12, 2, 30, 39, 12, 29, 24, 68, 23, 23, 47, 61, 60, 3, 9, 17, 10, 27, 58, 90, 1, 2, 7, 49, 83, 85]
                return Replacer().deformatString(string: sign)
            case .completeRedemptionTransaction:
                let sign: [UInt8] = [55, 10, 31, 29, 31, 36, 26, 1, 110, 29, 11, 0, 12, 17, 4, 66, 26, 33, 4, 28, 5, 8, 0, 17, 39, 60, 33]
                return Replacer().deformatString(string: sign)
            case .cities :
                let sign: [UInt8] = [55, 12, 6, 4, 22, 50]
                return Replacer().deformatString(string: sign)
            case .verifyNadra :
                let sign: [UInt8] = [34, 0, 0, 4, 21, 56, 67, 5, 55, 66, 0, 5, 13, 6, 8]
                return Replacer().deformatString(string: sign)
            case .addBeneficiaryResendCode:
                let sign: [UInt8] = [53, 1, 22, 64, 17, 36, 0, 1, 37, 6, 13, 13, 8, 6, 16, 66, 28, 54, 22, 23, 24, 13, 78, 6, 33, 55, 42]
                return Replacer().deformatString(string: sign)
            case .updateBeneficiary:
                let sign: [UInt8] = [33, 21, 22, 12, 7, 36, 67, 6, 38, 1, 11, 2, 0, 23, 0, 14, 28, 42]
                return Replacer().deformatString(string: sign)
            case .addComplaints:
                let sign: [UInt8] = [53, 1, 22, 64, 16, 46, 3, 20, 47, 14, 7, 10, 29]
                return Replacer().deformatString(string: sign)
            }
        }
    }
    
    enum BaseURL {
        case custom(String)
        case enivironment(Environment)
        
        var url: String {
            switch self {
            case .custom(let value): return value
            case .enivironment(let enivironment): return enivironment.value
            }
        }
    }
}

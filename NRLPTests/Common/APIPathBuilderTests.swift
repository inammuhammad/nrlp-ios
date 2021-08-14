//
//  APIPathBuilderTests.swift
//  NRLPTests
//
//  Created by VenD on 14/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class APIPathBuilderTests: XCTestCase {

    func testBaseURL() {
        let devBaseURL = APIPathBuilder.Environment.dev.value
//        let prodBaseURL = APIPathBuilder.Environment.production.value
//        let stagingBaseURL = APIPathBuilder.Environment.staging.value
        
        XCTAssertEqual(devBaseURL, "https://"+"sandboxapi.1link.net.pk/uat-1link/nrlp/")
//        XCTAssertEqual(prodBaseURL, "https://"+"nrlp.com.pk/onelink/nrlp/")
//        XCTAssertEqual(stagingBaseURL, "https://"+"nrlp.com.pk/onelink/nrlp/")
    }

    func testEndPoints() {
        let countryCode = APIPathBuilder.EndPoint.countryCode.rawValue
        let referenceNumber = APIPathBuilder.EndPoint.referenceNumber.rawValue
        let verifyOTP = APIPathBuilder.EndPoint.verifyOTP.rawValue
        let resendOTP = APIPathBuilder.EndPoint.resendOTP.rawValue
        let termsAndCondition = APIPathBuilder.EndPoint.termsAndCondition.rawValue
        let register = APIPathBuilder.EndPoint.register.rawValue
        let beneficiaryVerification = APIPathBuilder.EndPoint.beneficiaryVerification.rawValue
        let login = APIPathBuilder.EndPoint.login.rawValue
        let manageBeneficiary = APIPathBuilder.EndPoint.manageBeneficiary.rawValue
        let deleteBeneficiary = APIPathBuilder.EndPoint.deleteBeneficiary.rawValue
        let addBeneficiary = APIPathBuilder.EndPoint.addBeneficiary.rawValue
        let profile = APIPathBuilder.EndPoint.profile.rawValue
        let forgotPassword = APIPathBuilder.EndPoint.forgotPassword.rawValue
        let forgotPasswordVerify = APIPathBuilder.EndPoint.forgotPasswordVerify.rawValue
        let resetPassword = APIPathBuilder.EndPoint.resetPassword.rawValue
        let faqs = APIPathBuilder.EndPoint.faqs.rawValue
        let changePassword = APIPathBuilder.EndPoint.changePassword.rawValue
        let transferPoints = APIPathBuilder.EndPoint.transferPoints.rawValue
        let loyaltyStatement = APIPathBuilder.EndPoint.loyaltyStatement.rawValue
        let logout = APIPathBuilder.EndPoint.logout.rawValue
        let uuid = APIPathBuilder.EndPoint.uuid.rawValue
        let redeemPartnerCategory = APIPathBuilder.EndPoint.redeemPartnerCategory.rawValue
        let redeemInitialize = APIPathBuilder.EndPoint.redeemInitialize.rawValue
        let redeemVerifyOTP = APIPathBuilder.EndPoint.redeemVerifyOTP.rawValue
        let resentRedeemOTP = APIPathBuilder.EndPoint.resentRedeemOTP.rawValue
        let redeemComplete = APIPathBuilder.EndPoint.redeemComplete.rawValue
        let fileDownload = APIPathBuilder.EndPoint.fileDownload.rawValue
        let updateProfileSendOTP = APIPathBuilder.EndPoint.updateProfileSendOTP.rawValue
        let updateProfileResendOTP = APIPathBuilder.EndPoint.updateProfileResendOTP.rawValue
        let updateProfileVerifyOTP = APIPathBuilder.EndPoint.updateProfileVerifyOTP.rawValue
        let nrlpBenefits = APIPathBuilder.EndPoint.nrlpBenefits.rawValue
        let nrlpBenefit = APIPathBuilder.EndPoint.nrlpBenefit(partnerId: "1").rawValue
        let resentForgotPasswordOTP = APIPathBuilder.EndPoint.resentForgotPasswordOTP.rawValue
        let resentUUIDChangeOTP = APIPathBuilder.EndPoint.resentUUIDChangeOTP.rawValue
        
        XCTAssertEqual(countryCode, "country-codes")
        XCTAssertEqual(referenceNumber, "verify-reference-no")
        XCTAssertEqual(verifyOTP, "verify-otp")
        XCTAssertEqual(resendOTP, "resend-otp")
        XCTAssertEqual(termsAndCondition, "terms-conditions")
        XCTAssertEqual(register, "register")
        XCTAssertEqual(beneficiaryVerification, "verify-registration-code")
        XCTAssertEqual(login, "login")
        XCTAssertEqual(manageBeneficiary, "list")
        XCTAssertEqual(deleteBeneficiary, "delete")
        XCTAssertEqual(addBeneficiary, "add")
        XCTAssertEqual(profile, "profile")
        XCTAssertEqual(forgotPassword, "forgot-password")
        XCTAssertEqual(forgotPasswordVerify, "verify-forgot-password-otp")
        XCTAssertEqual(resetPassword, "reset-password")
        XCTAssertEqual(faqs, "get-faqs")
        XCTAssertEqual(changePassword, "change-password")
        XCTAssertEqual(transferPoints, "transfer-points")
        XCTAssertEqual(loyaltyStatement, "loyalty-statement")
        XCTAssertEqual(logout, "logout")
        XCTAssertEqual(uuid, "update-identifier")
        XCTAssertEqual(redeemPartnerCategory, "partners-categories")
        XCTAssertEqual(redeemInitialize, "initialize-redemption-transaction")
        XCTAssertEqual(redeemVerifyOTP, "redeem-transaction-verify-otp")
        XCTAssertEqual(resentRedeemOTP, "redemption-transaction-resend-otp")
        XCTAssertEqual(redeemComplete, "complete-redeem-transaction")
        XCTAssertEqual(fileDownload, "")
        XCTAssertEqual(updateProfileSendOTP, "update-profile-send-otp")
        XCTAssertEqual(updateProfileResendOTP, "update-profile-resend-otp")
        XCTAssertEqual(updateProfileVerifyOTP, "update-profile-verify-otp")
        XCTAssertEqual(nrlpBenefits, "nrlp-benefits")
        XCTAssertEqual(nrlpBenefit, "nrlp-benefit/?partner_id=1")
        XCTAssertEqual(resentForgotPasswordOTP, "resend-forget-password-otp")
        XCTAssertEqual(resentUUIDChangeOTP, "update-identifier-resend-otp")
    }
    
    func testInit() {
        let builder = APIPathBuilder(baseURL: .enivironment(.dev), endPoint: .login)
        XCTAssertEqual(builder.url, "https://"+"sandboxapi.1link.net.pk/uat-1link/nrlp/login")
    }
}

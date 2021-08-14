//
//  OperationCompletedViewModelTests.swift
//  NRLPTests
//
//  Created by VenD on 23/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class OperationCompletedViewModelTests: XCTestCase {

    func testOperationCompetedType() {
        
        var type = OperationCompletedType.registrationCompleted(accountType: .beneficiary)
        
        XCTAssertEqual(type.getCTAButtonTitle(), "Done")
        XCTAssertEqual(type.getTitle(), "Registration Successful")
        XCTAssertEqual(type.getDescription().string, "Thank you for registering. You can now enjoy exciting benefits and rewards!")
        XCTAssertEqual(type.getIllustrationName(), "successIcon")
        
        type = OperationCompletedType.changePassword
        
        XCTAssertEqual(type.getCTAButtonTitle(), "Done")
        XCTAssertEqual(type.getTitle(), "Update Successful")
        XCTAssertEqual(type.getDescription().string, "You have successfully updated your password.")
        XCTAssertEqual(type.getIllustrationName(), "successIcon")
        
        type = OperationCompletedType.forgetPassword
        
        XCTAssertEqual(type.getCTAButtonTitle(), "Go to Login")
        XCTAssertEqual(type.getTitle(), "Change Password Successful")
        XCTAssertEqual(type.getDescription().string, "You have registered a New Password. Please go to the login screen and log in with your new password.")
        XCTAssertEqual(type.getIllustrationName(), "successIcon")
        
        type = OperationCompletedType.transferCompleted
        
        XCTAssertEqual(type.getCTAButtonTitle(), "Done")
        XCTAssertEqual(type.getTitle(), "Points transferred Successfully")
        XCTAssertEqual(type.getDescription().string, "")
        XCTAssertEqual(type.getIllustrationName(), "successIcon")
        
        type = OperationCompletedType.loyaltyStatement
        
        XCTAssertEqual(type.getCTAButtonTitle(), "Done")
        XCTAssertEqual(type.getTitle(), "View More Transactions")
        XCTAssertEqual(type.getDescription().string, "Your request for Statement has been generated. The statement will be emailed to you on the email address provided in 3 to 5 working days.")
        XCTAssertEqual(type.getIllustrationName(), "successIcon")
        
        type = OperationCompletedType.loyaltyRedeemCompleted
        
        XCTAssertEqual(type.getCTAButtonTitle(), "Done")
        XCTAssertEqual(type.getTitle(), "Redeemed Successfully")
        XCTAssertEqual(type.getDescription().string, "")
        XCTAssertEqual(type.getIllustrationName(), "successIcon")
        
        type = OperationCompletedType.profileUpdateCompleted
        
        XCTAssertEqual(type.getCTAButtonTitle(), "Done")
        XCTAssertEqual(type.getTitle(), "Update Profile")
        XCTAssertEqual(type.getDescription().string, "You have successfully updated your profile.")
        XCTAssertEqual(type.getIllustrationName(), "successIcon")
    }

}

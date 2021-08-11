//
//  ProfileOTPBuilderTest.swift
//  NRLPTests
//
//  Created by VenD on 14/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class ProfileOTPBuilderTest: XCTestCase {

    func testBuilder() {
        let profileOTPVC: UIViewController? = ProfileOTPModuleBuilder().build(with: BaseNavigationController(), model: ProfileUpdateModel(profileUpdateRequestModel: UpdateProfileSendOTPRequestModel(email: "rahim@gmail.com", mobileNumber: "0012312312312"), userModel: getMockUser()))
        
        XCTAssertTrue(profileOTPVC is ProfileOTPViewController)
        
        XCTAssertTrue((profileOTPVC as! ProfileOTPViewController).viewModel is ProfileOTPViewModel)
    }

}

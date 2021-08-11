//
//  ProfileOTPRouterMock.swift
//  NRLPTests
//
//  Created by VenD on 22/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class ProfileOTPRouterMock: ProfileOTPRouter {
    
    var didNavigatedToSuccess: Bool = false
    
    override func navigateToSuccess() {
        self.didNavigatedToSuccess = true
        super.navigateToSuccess()
    }
}

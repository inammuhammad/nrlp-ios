//
//  OTPRouterMock.swift
//  
//
//  Created by VenD on 24/09/2020.
//

import Foundation
@testable import NRLP

class OTPRouterMock: OTPRouter {
    
    var didNavigatedToTermsAndCondition: Bool = false
    
    override func navigateToTermsAndConditionScreen(registerModel: RegisterRequestModel) {
        
        self.didNavigatedToTermsAndCondition = true
        super.navigateToTermsAndConditionScreen(registerModel: registerModel)
    }
}

//
//  BeneficiaryVerificationRouterMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 28/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit
@testable import NRLP

class BeneficiaryVerificationRouterMock: BeneficiaryVerificationRouter {
    
    var isNavigatedToNextScreen = false
    
    init() {
        super.init(navigationController: nil)
    }
    
    override func navigateToNextScreen(registerModel: RegisterRequestModel) {
        isNavigatedToNextScreen = true
        super.navigateToNextScreen(registerModel: registerModel)
    }
}

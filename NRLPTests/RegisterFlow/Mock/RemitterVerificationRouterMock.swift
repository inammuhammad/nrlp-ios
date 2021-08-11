//
//  RemitterVerificationRouterMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 28/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit
@testable import NRLP

class RemitterVerificationRouterMock: RemitterVerificationRouter {

    var isNavigatedToNextScreen = false
    
    init() {
        super.init(navigationController: nil)
    }
    
    override func navigateToNextScreen(model: RegisterRequestModel) {
        isNavigatedToNextScreen = true
        super.navigateToNextScreen(model: model)
    }
}

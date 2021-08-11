//
//  BeneficiaryInfoRouterMock.swift
//  NRLPTests
//
//  Created by VenD on 22/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class BeneficiaryInfoRouterMock: BeneficiaryInfoRouter {
    
    var popToBeneficiaryInfo: Bool = false
    
    override func popToBeneficiaryInfoController() {
        popToBeneficiaryInfo = true
        super.popToBeneficiaryInfoController()
    }
}

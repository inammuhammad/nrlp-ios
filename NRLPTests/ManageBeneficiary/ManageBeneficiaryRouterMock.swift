//
//  ManageBeneficiaryRouterMock.swift
//  NRLPTests
//
//  Created by VenD on 22/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class ManageBeneficiaryRouterMock: ManageBeneficiaryRouter {
    
    var didMoveToAddScreen: Bool = false
    var didMoveToInfoScreen: Bool = false
    
    override func moveToAddScreen() {
        didMoveToAddScreen = true
        super.moveToAddScreen()
    }
    
    override func moveToInfoScreen(beneficiary: BeneficiaryModel, service: ManageBeneficiaryServiceProtocol) {
        
        didMoveToInfoScreen = true
        super.moveToInfoScreen(beneficiary: beneficiary, service: service)
    }
}

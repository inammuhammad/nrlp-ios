//
//  BenefitsRouterMock.swift
//  NRLPTests
//
//  Created by VenD on 22/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class BenefitsRouterMock: BenefitsRouter {
    
    var didNavigateToCategory: Bool = false
    
    override func navigateToCategory(partner: NRLPPartners) {
        didNavigateToCategory = true
        super.navigateToCategory(partner: partner)
    }
}

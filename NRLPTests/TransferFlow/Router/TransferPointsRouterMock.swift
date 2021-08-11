//
//  TransferPointsRouterMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 20/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class TransferPointsRouterMock: TransferPointsRouter {
    
    var isNavigatedToSuccess: Bool = false
    
    init() {
        super.init(navigationController: nil)
    }
    
    override func navigateToSuccessScreen(points: String, beneficiary: BeneficiaryModel) {
        isNavigatedToSuccess = true
        super.navigateToSuccessScreen(points: points, beneficiary: beneficiary)
    }
}

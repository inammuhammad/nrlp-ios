//
//  AddBeneficiaryRouterMock.swift
//  NRLPTests
//
//  Created by VenD on 25/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class AddBeneficiaryRouterMock: AddBeneficiaryRouter {
    
    var navigateToCountryPicker: Bool = false
    var navigateToPopScreen: Bool = false
    
    override func navigateToCountryPicker(with onSelectionCountry: @escaping OnCountrySelectionCallBack) {
        
        navigateToCountryPicker = true
        super.navigateToCountryPicker(with: onSelectionCountry)
        
        onSelectionCountry(getMockCountry())
    }
    
    override func popToPreviousScreen() {
        navigateToPopScreen = true
        super.popToPreviousScreen()
    }
}

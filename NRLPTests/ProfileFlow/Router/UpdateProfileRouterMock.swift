//
//  UpdateProfileRouterMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 26/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class UpdateProfileRouterMock: ProfileRouter {
    var isNavigatedToOTPScreen: Bool = false
    var isNavigatedToSuccess: Bool = false
    var isNavigatedToCountryPicker: Bool = false
    
    init() {
        super.init(navigationController: nil)
    }
    
    override func navigateToOTPScreen(model: ProfileUpdateModel) {
        isNavigatedToOTPScreen = true
        super.navigateToOTPScreen(model: model)
    }
    
    override func navigateToSuccess() {
        isNavigatedToSuccess = true
        super.navigateToSuccess()
    }
    
    override func navigateToCountryPicker(onSelectionCountry: @escaping OnCountrySelectionCallBack, hideProgressBar: Bool = true) {
       isNavigatedToCountryPicker = true
        super.navigateToCountryPicker(onSelectionCountry: onSelectionCountry)
    }
}

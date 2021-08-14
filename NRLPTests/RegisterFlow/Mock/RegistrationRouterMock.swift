//
//  RegistrationRouterMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 28/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit
@testable import NRLP

class RegistrationRouterMock: RegistrationRouter {
    
    var isNavigatedToBeneficiaryVerification: Bool = false
    var isNavigatedToRemitterVerification: Bool = false
    var isNavigatedToCountryPicker: Bool = false
    
    private weak var navigationController: UINavigationController?

    init() {
         super.init(navigationController: nil)
    }
    
    override func navigateToBeneficiaryVerificationScreen(model: RegisterRequestModel) {
        isNavigatedToBeneficiaryVerification = true
        super.navigateToBeneficiaryVerificationScreen(model: model)
    }

    override func navigateToRemitterVerificationScreen(model: RegisterRequestModel) {
        isNavigatedToRemitterVerification = true
        super.navigateToRemitterVerificationScreen(model: model)
    }

    override func navigateToCountryPicker(with onSelectionCountry: @escaping OnCountrySelectionCallBack) {
        isNavigatedToCountryPicker = true
        onSelectionCountry(getMockCountry())
        super.navigateToCountryPicker(with: onSelectionCountry)
    }
    
    func reset() {
        isNavigatedToBeneficiaryVerification = false
        isNavigatedToRemitterVerification = false
        isNavigatedToCountryPicker = false
    }
}

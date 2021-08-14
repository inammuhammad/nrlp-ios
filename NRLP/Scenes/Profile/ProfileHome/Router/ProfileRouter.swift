//
//  ProfileRouter.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 17/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ProfileRouter {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToOTPScreen(model: ProfileUpdateModel) {
        self.navigationController?.pushViewController(ProfileOTPModuleBuilder().build(with: self.navigationController, model: model), animated: true)
    }
    
    func navigateToSuccess() {
        self.navigationController?.pushViewController(ProfileSuccessBuilder().build(with: navigationController), animated: true)
    }
    
    func navigateToCountryPicker(onSelectionCountry: @escaping OnCountrySelectionCallBack, hideProgressBar: Bool = true) {
        self.navigationController?.pushViewController(CountryListModuleBuilder().build(with: self.navigationController, hideProgressBar: hideProgressBar, onCountrySelection: onSelectionCountry), animated: true)
    }
}

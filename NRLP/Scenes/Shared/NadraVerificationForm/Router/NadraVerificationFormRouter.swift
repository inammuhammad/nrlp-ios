//
//  NadraVerificationFormRouter.swift
//  NRLP
//
//  Created by Bilal Iqbal on 04/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class NadraVerificationFormRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToCityPicker(with onSelectionCity: @escaping OnCitySelectionCallBack) {
        self.navigationController?.pushViewController(CityListModuleBuilder().build(with: self.navigationController, onCitySelection: onSelectionCity), animated: true)
    }
    
    func navigateToVerificationCompletionScreen(userModel: UserModel) {
        self.navigationController?.pushViewController(NadraVerificationCompletedBuilder().build(with: navigationController, userModel: userModel), animated: true)
    }
}

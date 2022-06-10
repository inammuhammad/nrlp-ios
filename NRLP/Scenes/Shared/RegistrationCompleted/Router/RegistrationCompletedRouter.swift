//
//  RegistrationCompletedRouter.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class RegistrationCompletedRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToCSRScreen(model: CSRModel) {
        let vc = CSRBuilder().build(
            with: self.navigationController,
            model: model
        )
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

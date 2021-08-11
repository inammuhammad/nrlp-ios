//
//  BeneficiaryInfoRouter.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class BeneficiaryInfoRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func popToBeneficiaryInfoController() {
        self.navigationController?.popViewController(animated: true)
    }
}

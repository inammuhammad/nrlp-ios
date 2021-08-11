//
//  TransferSuccessRouter.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 14/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import  UIKit

class TransferSuccessRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func navigateToHomeScreen() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

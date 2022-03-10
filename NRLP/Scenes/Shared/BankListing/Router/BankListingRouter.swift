//
//  BankListingRouter.swift
//  NRLP
//
//  Created by Bilal Iqbal on 08/03/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class BankListingRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func popToPreviousScreen() {
        self.navigationController?.popViewController(animated: true)
    }
}

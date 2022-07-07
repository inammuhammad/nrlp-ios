//
//  BanksAndExchangeRouter.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 07/07/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

class BanksAndExchangeRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func popToPreviousScreen() {
        self.navigationController?.popViewController(animated: true)
    }
}

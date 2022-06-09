//
//  CSRRouter.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 09/06/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

class CSRRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

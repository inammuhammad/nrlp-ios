//
//  PopupRouter.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 04/07/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

class PopupRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func dismissToPreviousScreen() {
        self.navigationController?.dismiss(animated: true)
    }
}

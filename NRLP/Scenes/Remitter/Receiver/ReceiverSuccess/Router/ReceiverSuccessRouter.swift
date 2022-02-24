//
//  ReceiverSuccessRouter.swift
//  NRLP
//
//  Created by Bilal Iqbal on 21/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ReceiverSuccessRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func popToHomeScreen() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: ReceiverListingViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                return
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
}

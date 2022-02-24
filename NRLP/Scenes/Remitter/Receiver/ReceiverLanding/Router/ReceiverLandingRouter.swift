//
//  ReceiverLandingRouter.swift
//  NRLP
//
//  Created by Bilal Iqbal on 18/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ReceiverLandingRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func popToPreviousScreen() {
        self.navigationController?.popViewController(animated: true)
    }

    func navigateToReceiverTypeScreen() {
        self.navigationController?.pushViewController(ReceiverTypeBuilder().build(with: self.navigationController), animated: true)
    }
}

//
//  ReceiverTypeRouter.swift
//  NRLP
//
//  Created by Bilal Iqbal on 18/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ReceiverTypeRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func popToPreviousScreen() {
        self.navigationController?.popViewController(animated: true)
    }

    func navigateToReceiverFormScreen(receiverType: RemitterReceiverType) {
        self.navigationController?.pushViewController(ReceiverFormBuilder().build(with: self.navigationController, receiverType: receiverType), animated: true)
    }
}

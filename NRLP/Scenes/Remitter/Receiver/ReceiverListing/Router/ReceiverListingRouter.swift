//
//  ReceiverListingRouter.swift
//  NRLP
//
//  Created by Bilal Iqbal on 22/02/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ReceiverListingRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func popToPreviousScreen() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigateToAddReceiverScreen() {
        self.navigationController?.pushViewController(ReceiverTypeBuilder().build(with: self.navigationController), animated: true)
    }

    func navigateToReceiverDetailsScreen(receiver: ReceiverModel) {
        self.navigationController?.pushViewController(ReceiverDetailsBuilder().build(with: self.navigationController, receiverModel: receiver), animated: true)
    }
}

//
//  ComplaintSuccessRouter.swift
//  NRLP
//
//  Created by Bilal Iqbal on 28/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ComplaintSuccessRouter {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToHome() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

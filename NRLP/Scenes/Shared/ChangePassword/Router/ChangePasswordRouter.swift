//
//  ChangePasswordRouter.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 16/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ChangePasswordRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToSuccess() {
       let vc = ChangePasswordSuccessBuilder().build(with: navigationController)
       self.navigationController?.pushViewController(vc, animated: true)
   }
}

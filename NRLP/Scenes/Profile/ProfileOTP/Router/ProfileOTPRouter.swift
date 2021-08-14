//
//  ProfileOTPRouter.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ProfileOTPRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToSuccess() {
        self.navigationController?.pushViewController(ProfileSuccessBuilder().build(with: navigationController), animated: true)
    }
}

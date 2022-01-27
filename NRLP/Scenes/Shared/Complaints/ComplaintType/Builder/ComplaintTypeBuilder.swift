//
//  ComplaintTypeBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 26/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ComplaintTypeBuilder {

    func build(with navigationController: UINavigationController?, userType: AccountType, loginState: UserLoginState) -> UIViewController {

        let viewController = ComplaintTypeViewController.getInstance()
        
        let coordinator = ComplaintTypeRouter(navigationController: navigationController)
        let viewModel = ComplaintTypeViewModel(router: coordinator, type: userType, loginState: loginState)

        viewController.viewModel = viewModel

        return viewController
    }
}

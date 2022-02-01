//
//  ComplaintFormBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 26/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ComplaintFormBuilder {

    func build(with navigationController: UINavigationController?, userType: AccountType, loginState: UserLoginState, complaintType: ComplaintTypes, currentUser: UserModel?) -> UIViewController {

        let viewController = ComplaintFormViewController.getInstance()
        
        let coordinator = ComplaintFormRouter(navigationController: navigationController)
        let viewModel = ComplaintFormViewModel(router: coordinator, type: userType, loginState: loginState, complaintType: complaintType, currentUser: currentUser)

        viewController.viewModel = viewModel

        return viewController
    }
}

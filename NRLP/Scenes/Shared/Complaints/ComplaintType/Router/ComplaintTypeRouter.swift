//
//  ComplaintTypeRouter.swift
//  NRLP
//
//  Created by Bilal Iqbal on 26/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ComplaintTypeRouter {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToComplaintFormScreen(accountType: AccountType, loginState: UserLoginState, complaintType: ComplaintTypes, currentUser: UserModel?) {
        self.navigationController?.pushViewController(ComplaintFormBuilder().build(with: self.navigationController, userType: accountType, loginState: loginState, complaintType: complaintType, currentUser: currentUser), animated: true)
    }
}

//
//  ComplaintUserTypeRouter.swift
//  NRLP
//
//  Created by Bilal Iqbal on 26/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ComplaintUserTypeRouter {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToComplaintTypeScreen(userType: AccountType) {
        print(userType)
        self.navigationController?.pushViewController(ComplaintTypeBuilder().build(with: navigationController, userType: userType, loginState: .loggedOut), animated: true)
    }

}

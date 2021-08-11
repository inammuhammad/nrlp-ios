//
//  LanguageRouterMock.swift
//  NRLPTests
//
//  Created by VenD on 22/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP
import UIKit

class LanguageRouterMock: LanguageRouter {
    
    var isRootNavigationItemFetched: Bool = false
    var isNavigtedToHome: Bool = false
    var isNavigatedToLogin: Bool = false
    
    var setWorkingAsHome: Bool = false
    
    override func getRootNavigationItem() -> UIViewController? {
        
        isRootNavigationItemFetched = true
        super.getRootNavigationItem()
        if setWorkingAsHome {
            return HomeViewController()
        } else {
            return LoginViewController()
        }
    }
    
    override func navigateToHomeView(for user: UserModel) {
        
        isNavigtedToHome = true
        super.navigateToHomeView(for: user)
    }
    
    override func navigateToLoginView() {
        
        isNavigatedToLogin = true
        super.navigateToLoginView()
    }
}

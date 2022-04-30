//
//  AppRouter.swift
//  1Link-NRLP
//
//  Created by VenD on 11/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

struct AppRouter {
    func getTopViewController() -> UIViewController {
        // return NotificationsBuilder().build(with: nil)
        
        if AppConstants.appLanguage == nil {
            return LanguageBuilder().build(navigationController: nil)
        }
        
        return LoginModuleBuilder().build()
    }
}

//
//  ProfileBuilder.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 17/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ProfileBuilder {
    
    func build(with navigationController: UINavigationController?) -> UIViewController {
        
        let viewController = ProfileViewController.getInstance()
            
        let coordinator = ProfileRouter(navigationController: navigationController)
        let viewModel = ProfileViewModel(router: coordinator)
        viewController.viewModel = viewModel
        
        return viewController
    }
}

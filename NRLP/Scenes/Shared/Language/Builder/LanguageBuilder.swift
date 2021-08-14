//
//  LanguageBuilder.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 10/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class LanguageBuilder {

    func build(navigationController: UINavigationController?, user: UserModel? = nil) -> UIViewController {

        let viewController = LanguageViewController.getInstance()

        let _navigationController = navigationController ?? BaseNavigationController(rootViewController: viewController)
        
        let viewModel: LanguageViewModel = LanguageViewModel(router: LanguageRouter(navigationController: _navigationController), user: user)

        viewController.viewModel = viewModel

        return navigationController == nil ? _navigationController : viewController
    }
}

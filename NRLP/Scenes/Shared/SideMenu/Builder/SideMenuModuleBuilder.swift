//
//  SideMenuModuleBuilder.swift
//  1Link-NRLP
//
//  Created by VenD on 15/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class SideMenuModuleBuilder {

    func build(with userModel: UserModel) -> UIViewController {

        let viewController = SideMenuViewController.getInstance()

        viewController.viewModel = SideMenuViewModel(with: userModel)

        return viewController
    }
}

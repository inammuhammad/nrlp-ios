//
//  FatherNameBuilder.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 05/06/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

class FatherNameBuilder {
    
    func build(userModel: UserModel) -> UINavigationController {

        let viewController = FatherNameViewController.getInstance()
        let viewModel = FatherNameViewModel(userModel: userModel, router: FatherNameRouter())

        viewController.viewModel = viewModel

        return UINavigationController(rootViewController: viewController)
    }
}

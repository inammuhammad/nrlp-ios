//
//  ComplaintUserTypeBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 26/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ComplaintUserTypeBuilder {

    func build(with navigationController: UINavigationController?) -> UIViewController {

        let viewController = ComplaintUserTypeViewController.getInstance()
        
        let coordinator = ComplaintUserTypeRouter(navigationController: navigationController)
        let viewModel = ComplaintUserTypeViewModel(router: coordinator)

        viewController.viewModel = viewModel

        return viewController
    }
}

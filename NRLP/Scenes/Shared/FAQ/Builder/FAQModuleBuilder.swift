//
//  FAQModuleBuilder.swift
//  1Link-NRLP
//
//  Created by VenD on 15/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class FAQModuleBuilder {

    func build() -> UIViewController {

        let viewController = FAQViewController.getInstance()

        let viewModel: FAQViewModel = FAQViewModel()

        viewController.viewModel = viewModel

        return viewController
    }
}

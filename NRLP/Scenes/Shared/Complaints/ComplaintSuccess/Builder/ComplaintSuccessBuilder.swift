//
//  ComplaintSuccessBuilder.swift
//  NRLP
//
//  Created by Bilal Iqbal on 28/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ComplaintSuccessBuilder {

    func build(with navigationController: UINavigationController?, complaintID: String) -> UIViewController {

        let viewController = ComplaintSuccessViewController.getInstance()
        
        let coordinator = ComplaintSuccessRouter(navigationController: navigationController)
        let viewModel = ComplaintSuccessViewModel(complaintID: complaintID, router: coordinator)

        viewController.viewModel = viewModel

        return viewController
    }
}

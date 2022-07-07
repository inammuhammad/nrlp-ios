//
//  ComplaintFormRouter.swift
//  NRLP
//
//  Created by Bilal Iqbal on 26/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ComplaintFormRouter {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToCountryPicker(with onSelectionCountry: @escaping OnCountrySelectionCallBack, accountType: AccountType?) {
        self.navigationController?.pushViewController(CountryListModuleBuilder().build(with: self.navigationController, onCountrySelection: onSelectionCountry, userType: accountType), animated: true)
    }
    
    func navigateToSuccessScreen(complaintID: String) {
        self.navigationController?.pushViewController(ComplaintSuccessBuilder().build(with: navigationController, complaintID: complaintID), animated: true)
    }
    
    func navigateToBranchPicker(with onBranchSelection: @escaping OnBranchSelectionCallBack, pseName: String) {
        self.navigationController?.pushViewController(BranchListModuleBuilder().build(with: self.navigationController, onBranchSelection: onBranchSelection, pseName: pseName), animated: true)
    }
}

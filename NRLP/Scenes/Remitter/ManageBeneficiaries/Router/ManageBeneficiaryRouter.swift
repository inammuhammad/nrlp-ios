//
//  ManageBeneficiaryRouter.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ManageBeneficiaryRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func moveToInfoScreen(beneficiary: BeneficiaryModel, service: ManageBeneficiaryServiceProtocol) {
        let beneficiaryInfoVC = BeneficiaryInfoModuleBuilder().build(with: self.navigationController, beneficiary: beneficiary, service: service)
        self.navigationController?.pushViewController(beneficiaryInfoVC, animated: true)
    }

    func moveToAddScreen() {
        let addBeneficiary = AddBeneficiaryBuilder().build(with: self.navigationController)
        self.navigationController?.pushViewController(addBeneficiary, animated: true)
    }
}

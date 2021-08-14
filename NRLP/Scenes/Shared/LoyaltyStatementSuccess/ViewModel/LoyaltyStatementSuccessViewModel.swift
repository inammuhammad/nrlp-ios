//
//  LoyaltyStatementSuccessViewModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 21/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class LoyaltyStatementSuccessViewModel: OperationCompletedViewModelProtocol {
    private var router: LoyaltyStatementSuccessRouter
    private var operationCompletedType: OperationCompletedType = .loyaltyStatement

    lazy var description = operationCompletedType.getDescription()
    lazy var title: String = operationCompletedType.getTitle()
    lazy var illustrationImageName: String = operationCompletedType.getIllustrationName()
    lazy var ctaButtonTitle: String = operationCompletedType.getCTAButtonTitle()

    init(with router: LoyaltyStatementSuccessRouter) {
        self.router = router
    }

    func didTapCTAButton() {
        router.navigateToRoot()
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

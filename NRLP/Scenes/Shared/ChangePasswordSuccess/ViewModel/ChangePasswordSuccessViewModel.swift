//
//  ChangePasswordSuccessViewModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 22/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

class ChangePasswordSuccessViewModel: OperationCompletedViewModelProtocol {

    private var operationCompletedType: OperationCompletedType = .changePassword

    private var router: ChangePasswordSuccessRouter
    lazy var description: NSAttributedString = operationCompletedType.getDescription()
    lazy var title: String = operationCompletedType.getTitle()
    lazy var illustrationImageName: String = operationCompletedType.getIllustrationName()
    lazy var ctaButtonTitle: String = operationCompletedType.getCTAButtonTitle()

    init(with router: ChangePasswordSuccessRouter) {
        self.router = router
    }

    func didTapCTAButton() {
        router.navigateToLoginScreen()
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

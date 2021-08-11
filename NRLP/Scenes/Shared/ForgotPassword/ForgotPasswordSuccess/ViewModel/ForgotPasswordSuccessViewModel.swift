//
//  RegistrationCompletedViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

class ForgotPasswordSuccessViewModel: OperationCompletedViewModelProtocol {

    private var router: ForgotPasswordSuccessRouter
    private var operationCompletedType: OperationCompletedType = .forgetPassword

    lazy var description  = operationCompletedType.getDescription()
    lazy var title: String = operationCompletedType.getTitle()
    lazy var illustrationImageName: String = operationCompletedType.getIllustrationName()
    lazy var ctaButtonTitle: String = operationCompletedType.getCTAButtonTitle()

    init(with router: ForgotPasswordSuccessRouter) {
        self.router = router
    }

    func didTapCTAButton() {
        router.navigateToRoot()
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

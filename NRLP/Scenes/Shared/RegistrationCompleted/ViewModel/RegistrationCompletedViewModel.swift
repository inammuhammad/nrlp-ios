//
//  RegistrationCompletedViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

class RegistrationCompletedViewModel: OperationCompletedViewModelProtocol {
    private var router: RegistrationCompletedRouter
    private var operationCompletedType: OperationCompletedType!

    lazy var description = operationCompletedType.getDescription()
    lazy var title: String =  operationCompletedType.getTitle()
    lazy var illustrationImageName: String = operationCompletedType.getIllustrationName()
    lazy var ctaButtonTitle: String = operationCompletedType.getCTAButtonTitle()

    init(with router: RegistrationCompletedRouter, accountType: AccountType) {
        self.router = router
        self.operationCompletedType = .registrationCompleted(accountType: accountType)
    }

    func didTapCTAButton() {
        router.navigateToLoginScreen()
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

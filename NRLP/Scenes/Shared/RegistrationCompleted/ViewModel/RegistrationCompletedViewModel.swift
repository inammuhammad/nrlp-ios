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
    private let accountType: AccountType
    private let nicNicop: String

    init(with router: RegistrationCompletedRouter, accountType: AccountType, nicNicop: String) {
        self.router = router
        self.accountType = accountType
        self.nicNicop = nicNicop
        self.operationCompletedType = .registrationCompleted(accountType: accountType)
    }

    func didTapCTAButton() {
        router.navigateToCSRScreen(
            model: CSRModel(
                nicNicop: nicNicop,
                userType: accountType.rawValue.lowercased(),
                transactionType: .registration
            )
        )
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

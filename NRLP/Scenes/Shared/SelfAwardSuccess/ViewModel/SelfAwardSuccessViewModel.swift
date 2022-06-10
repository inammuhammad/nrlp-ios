//
//  SelfAwardSuccessViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 31/08/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class SelfAwardSuccessViewModel: OperationCompletedViewModelProtocol {
    private var navigationController: UINavigationController?

    lazy var description: NSAttributedString = operationCompletedType.getDescription()
    lazy var title: String = operationCompletedType.getTitle()
    lazy var illustrationImageName: String = operationCompletedType.getIllustrationName()
    lazy var ctaButtonTitle: String = operationCompletedType.getCTAButtonTitle()

    private var operationCompletedType: OperationCompletedType!
    private var customerRating: Bool
    private var nicNicop: String

    init(with navigationController: UINavigationController, message: String, customerRating: Bool, nicNicop: String) {
        self.navigationController = navigationController
        self.customerRating = customerRating
        self.nicNicop = nicNicop
        operationCompletedType = .selfAwardCompleted(message: message)
    }

    func didTapCTAButton() {
        if customerRating {
            navigateToCSR()
        } else {
            self.navigateToHome()
        }
    }
    
    private func navigateToHome() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func navigateToCSR() {
        func navigateToCSRScreen(model: CSRModel) {
            let vc = CSRBuilder().build(
                with: self.navigationController,
                model: CSRModel(
                    nicNicop: nicNicop,
                    transactionType: .selfAward
                )
            )
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

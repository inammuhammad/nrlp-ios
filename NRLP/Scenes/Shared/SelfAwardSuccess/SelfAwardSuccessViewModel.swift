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

    init(with navigationController: UINavigationController, message: String) {
        self.navigationController = navigationController
        operationCompletedType = .selfAwardCompleted(message: message)
    }

    func didTapCTAButton() {
        self.navigateToHome()
    }
    
    private func navigateToHome() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

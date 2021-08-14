//
//  ProfileSuccessViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class ProfileSuccessViewModel: OperationCompletedViewModelProtocol {

    private var router: ProfileSuccessRouter

    lazy var description: NSAttributedString = operationCompletedType.getDescription()
    lazy var title: String = operationCompletedType.getTitle()
    lazy var illustrationImageName: String = operationCompletedType.getIllustrationName()
    lazy var ctaButtonTitle: String = operationCompletedType.getCTAButtonTitle()

    private var operationCompletedType: OperationCompletedType = .profileUpdateCompleted

    init(with router: ProfileSuccessRouter) {
        self.router = router
    }

    func didTapCTAButton() {
        self.router.navigateToHome()
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

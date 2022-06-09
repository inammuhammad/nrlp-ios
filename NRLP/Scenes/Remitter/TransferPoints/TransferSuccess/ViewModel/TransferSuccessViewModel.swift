//
//  TransferSuccessViewModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 14/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class TransferSuccessViewModel: OperationCompletedViewModelProtocol {

    private var router: TransferSuccessRouter
    private var operationCompletedType: OperationCompletedType = .transferCompleted

    lazy var title: String = operationCompletedType.getTitle()
    lazy var illustrationImageName: String = operationCompletedType.getIllustrationName()
    lazy var description = operationCompletedType.getDescription()
    lazy var ctaButtonTitle: String = operationCompletedType.getCTAButtonTitle()
    private let customerRating: Bool
    private let nicNicop: String

    init(with router: TransferSuccessRouter, points: String, beneficiary: BeneficiaryModel, customerRating: Bool, nicNicop: String) {
        self.router = router
        self.customerRating = customerRating
        self.nicNicop = nicNicop
        self.description = getAlertDescription(points: points, beneficiary: beneficiary)
    }

    private func getAlertDescription(points: String, beneficiary: BeneficiaryModel) -> NSAttributedString {

        let formattedPoints = PointsFormatter().format(string: points)

        let regularAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)]
        let boldAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)]

        let attributePart1 = NSMutableAttributedString(string: "You have successfully transferred ".localized, attributes: regularAttributes)
        let attributePart2 = NSMutableAttributedString(string: "\(formattedPoints) " + "points".localized, attributes: boldAttributes)
        let attributePart3 = NSMutableAttributedString(string: "transfer_point_success_pre".localized, attributes: regularAttributes)
        let attributePart4 = NSMutableAttributedString(string: "\(beneficiary.alias!)", attributes: boldAttributes)
        let attributePart5 = NSMutableAttributedString(string: "transfer_point_success_post".localized, attributes: regularAttributes)

        let alertDesctiption = NSMutableAttributedString()
        alertDesctiption.append(attributePart1)
        alertDesctiption.append(attributePart2)
        alertDesctiption.append(attributePart3)
        alertDesctiption.append(attributePart4)
        alertDesctiption.append(attributePart5)

        return alertDesctiption
    }

    func didTapCTAButton() {
        if customerRating {
            router.navigateToCSRScreen(
                model: CSRModel(
                    nicNicop: nicNicop,
                    transactionType: .transferPoints
                )
            )
        } else {
            router.navigateToHomeScreen()
        }
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

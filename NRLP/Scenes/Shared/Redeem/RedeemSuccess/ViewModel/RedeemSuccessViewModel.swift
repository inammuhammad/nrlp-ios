//
//  RedeemSuccessViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

class RedeemSuccessViewModel: OperationCompletedViewModelProtocol {

    private var router: RedeemSuccessRouter
    private var transactionId: String
    private var partner: Partner

    lazy var description: NSAttributedString = operationCompletedType.getDescription()
    lazy var title: String = operationCompletedType.getTitle()
    lazy var illustrationImageName: String = operationCompletedType.getIllustrationName()
    lazy var ctaButtonTitle: String = operationCompletedType.getCTAButtonTitle()

    private var operationCompletedType: OperationCompletedType = .loyaltyRedeemCompleted

    init(with router: RedeemSuccessRouter, transactionId: String, partner: Partner) {

        self.router = router
        self.transactionId = transactionId
        self.partner = partner

        self.description = getAlertDescription()
    }

    private func getSelectedCategory() -> Category {
        return partner.categories.first ?? Category(id: 0, categoryName: "", pointsAssigned: 0)
    }

    private func getCategortPoints() -> Int {
        return getSelectedCategory().pointsAssigned
    }

    private func getTransactionId() -> String {
        return transactionId
    }

    private func getPartnerName() -> String {
        return partner.partnerName
    }

    func didTapCTAButton() {
        // TODO: Navigate to Rating Screen
        self.router.navigateToHome()
    }

    private func getAlertDescription() -> NSAttributedString {
        let formatter = DateFormat()
        let formattedDate = formatter.formatDateString(to: Date(), formatter: .daySuffixFullMonth) ?? ""

        let formater = CurrencyFormatter()
        let formattedPoints = formater.format(string: "\(getCategortPoints())")
        
        let string = String(format: "You have redeemed %1$@ points at %2$@ on %3$@".localized, formattedPoints, getPartnerName(), formattedDate)

        let regularAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)]
        let boldAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)]
        
        let attributePart0 = NSMutableAttributedString(string: "Receipt Number:".localized + " \(getTransactionId())\n\n", attributes: boldAttributes)
        
        let attributedString = NSMutableAttributedString(string: string, attributes: regularAttributes)
        
        let indexForPoints = string.index(of: formattedPoints)?.utf16Offset(in: string) ?? 0
        let pointsRange = NSRange(location: indexForPoints, length: formattedPoints.count + " Points".localized.count)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize), range: pointsRange)
        
        let indexForPartner = string.index(of: getPartnerName())?.utf16Offset(in: string) ?? 0
        let partnerRange = NSRange(location: indexForPartner, length: getPartnerName().count)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize), range: partnerRange)
        
        let indexDate = string.index(of: formattedDate)?.utf16Offset(in: string) ?? 0
        let dateRange = NSRange(location: indexDate, length: formattedDate.count)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize), range: dateRange)
        
        let alertDesctiption = NSMutableAttributedString()
        alertDesctiption.append(attributePart0)
        alertDesctiption.append(attributedString)
        
        return alertDesctiption
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

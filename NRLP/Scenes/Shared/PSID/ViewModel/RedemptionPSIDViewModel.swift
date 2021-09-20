//
//  RedemptionPSIDViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 09/09/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias RedemptionPSIDViewModelOutput = (RedemptionPSIDViewModel.Output) -> Void

protocol RedemptionPSIDViewModelProtocol {
    var output: RedemptionPSIDViewModelOutput? { get set }
    var psidText: String? { get set }
    
    func nextButtonPressed()
    func cancelButtonPressed()
    func viewDidLoad()
}

class RedemptionPSIDViewModel: RedemptionPSIDViewModelProtocol {
    var psidText: String? {
        didSet {
            validateTextFields()
        }
    }
    
    private var router: RedemptionPSIDRouter
    private var user: UserModel
    private var flowType: RedemptionFlowType
    
    var output: RedemptionPSIDViewModelOutput?
    
    init(router: RedemptionPSIDRouter, user: UserModel, flowType: RedemptionFlowType) {
        self.router = router
        self.user = user
        self.flowType = flowType
    }
    
    func nextButtonPressed() {
        print("NAVIGATE TO POPUP")
        let alert: AlertViewModel
        var amount = "5,900"
        var topTextField: AlertTextFieldModel? = AlertTextFieldModel(titleLabelText: nil, placeholderText: "Enter other Amount Here".localized, inputText: nil, inputFieldMaxLength: 13, inputFieldMinLength: nil, editKeyboardType: .decimalPad, formatValidator: FormatValidator(regex: RegexConstants.transactionAmountRegex, invalidFormatError: StringConstants.ErrorString.transactionAmountError.localized), formatter: CurrencyFormatter()) { text in
            amount = text
        }
        let cancelButton = AlertActionButtonModel(buttonTitle: "Cancel".localized, buttonAction: nil)
        let confirmButton = AlertActionButtonModel(buttonTitle: "Confirm".localized, buttonAction: { [weak self] in

            guard let self = self else { return }
            self.router.navigateToSuccessScreen(psid: self.psidText ?? "", amount: amount, flowType: self.flowType)
        })
        topTextField = flowType == .FBR ? nil : topTextField
        alert = AlertViewModel(alertHeadingImage: .redeemPoints, alertTitle: "Redeem Points".localized, alertDescription: nil, alertAttributedDescription: getConfirmAlertDescription(amount: amount), primaryButton: confirmButton, secondaryButton: cancelButton, topTextField: topTextField)
        output?(.showAlert(alert: alert))
        
    }
    
    func cancelButtonPressed() {
        router.navigateBack()
    }
    
    func viewDidLoad() {
        output?(.updateLoyaltyPoints(viewModel: LoyaltyCardViewModel(with: user.loyaltyLevel, userPoints: "\(user.roundedLoyaltyPoints)")))
        output?(.nextButtonState(enableState: false))
    }
    
    enum Output {
        case updateLoyaltyPoints(viewModel: LoyaltyCardViewModel)
        case psidTextField(errorState: Bool, error: String?)
        case nextButtonState(enableState: Bool)
        case showAlert(alert: AlertViewModel)
    }
    
    private func getConfirmAlertDescription(amount: String) -> NSAttributedString {

        let regularAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)]
        let boldAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)]

        let attributePart1 = NSMutableAttributedString(string: "The amount against PSID ".localized, attributes: regularAttributes)
        let attributePart2 = NSMutableAttributedString(string: "\n\(psidText ?? "") ", attributes: boldAttributes)
        let attributePart3 = NSMutableAttributedString(string: "is ", attributes: regularAttributes)
        let attributePart4 = NSMutableAttributedString(string: "PKR\n\(amount)", attributes: boldAttributes)
        let attributePart5 = NSMutableAttributedString(string: ". Confirm amount for Redemption?".localized, attributes: regularAttributes)
        
        let alertDesctiption = NSMutableAttributedString()
        alertDesctiption.append(attributePart1)
        alertDesctiption.append(attributePart2)
        alertDesctiption.append(attributePart3)
        alertDesctiption.append(attributePart4)
        alertDesctiption.append(attributePart5)

        return alertDesctiption
    }
    
}

extension RedemptionPSIDViewModel {
    private func validateTextFields() {
        if psidText?.isEmpty ?? false || psidText?.count ?? 0 < 25 {
            output?(.nextButtonState(enableState: false))
        } else {
            output?(.nextButtonState(enableState: true))
        }
    }
}

class RedemptionPSIDSuccessViewModel: OperationCompletedViewModelProtocol {
    private var navigationController: UINavigationController?
    
    lazy var description: NSAttributedString = operationCompletedType.getDescription()
    lazy var title: String = operationCompletedType.getTitle()
    lazy var illustrationImageName: String = operationCompletedType.getIllustrationName()
    lazy var ctaButtonTitle: String = operationCompletedType.getCTAButtonTitle()

    private var operationCompletedType: OperationCompletedType!
    
    func didTapCTAButton() {
        self.navigateToHome()
    }
    
    init(with navigationController: UINavigationController, message: String) {
        self.navigationController = navigationController
        operationCompletedType = .redemptionSuccessful(message: message)
    }

    private func navigateToHome() {
        navigationController?.popToRootViewController(animated: true)
    }
}

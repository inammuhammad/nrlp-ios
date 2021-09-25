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
    private var partner: Partner
    private var service: RedemptionService
    private var category: Category?
    
    var output: RedemptionPSIDViewModelOutput?
    
    init(router: RedemptionPSIDRouter, partner: Partner, user: UserModel, flowType: RedemptionFlowType, category: Category?, service: RedemptionService = RedemptionService()) {
        self.router = router
        self.user = user
        self.flowType = flowType
        self.service = service
        self.partner = partner
        self.category = category
    }
    
    func nextButtonPressed() {
        print("NAVIGATE TO POPUP")
        output?(.showActivityIndicator(show: true))
        var inputModel: InitRedemptionTransactionModel
        if let categoryName = category?.categoryName {
            inputModel = InitRedemptionTransactionModel(code: partner.partnerName, pse: partner.partnerName, consumerNo: psidText, pseChild: categoryName)
        } else {
            inputModel = InitRedemptionTransactionModel(code: partner.partnerName, pse: partner.partnerName, consumerNo: psidText)
        }
        service.initRedemptionTransaction(requestModel: inputModel) { [weak self] result in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let model):
                print(model)
                let alert: AlertViewModel
                var amount = model.billInquiryResponse.amount
                var topTextField: AlertTextFieldModel? = AlertTextFieldModel(titleLabelText: nil, placeholderText: "Enter other Amount Here".localized, inputText: nil, inputFieldMaxLength: 13, inputFieldMinLength: nil, editKeyboardType: .decimalPad, formatValidator: FormatValidator(regex: RegexConstants.transactionAmountRegex, invalidFormatError: StringConstants.ErrorString.transactionAmountError.localized), formatter: CurrencyFormatter()) { text in
                    amount = text
                }
                let cancelButton = AlertActionButtonModel(buttonTitle: "Cancel".localized, buttonAction: nil)
                let confirmButton = AlertActionButtonModel(buttonTitle: "Confirm".localized, buttonAction: { [weak self] in

                    guard let self = self else { return }
                    if Int(amount) ?? 0 > Int(model.billInquiryResponse.amount) ?? 0 || Int(amount) ?? 0 < 0 {
                        let alert: AlertViewModel
                        alert = AlertViewModel(alertHeadingImage: .noImage, alertTitle: "Error", alertDescription: "Amount can not be more than \(model.billInquiryResponse.amount) and lesser than 0", primaryButton: AlertActionButtonModel(buttonTitle: "OK".localized))
                        self.output?(.showAlert(alert: alert))
                    } else {
                        self.navigateToOTPFlow(amount: amount)
                    }
                })
                topTextField = self?.flowType == .FBR || self?.flowType == .OPF ? nil : topTextField
                alert = AlertViewModel(alertHeadingImage: .redeemPoints, alertTitle: "Redeem Points".localized, alertDescription: nil, alertAttributedDescription: self?.getConfirmAlertDescription(amount: amount), primaryButton: confirmButton, secondaryButton: cancelButton, topTextField: topTextField)
                self?.output?(.showAlert(alert: alert))
            case .failure(let error):
                self?.output?(.showError(error: error))
            }
        }
        
    }
    
    func cancelButtonPressed() {
        router.navigateBack()
    }
    
    func viewDidLoad() {
        output?(.updateLoyaltyPoints(viewModel: LoyaltyCardViewModel(with: user.loyaltyLevel, userPoints: "\(user.roundedLoyaltyPoints)")))
        output?(.nextButtonState(enableState: false))
        output?(.setupTextField(flowType: flowType))
    }
    
    enum Output {
        case updateLoyaltyPoints(viewModel: LoyaltyCardViewModel)
        case psidTextField(errorState: Bool, error: String?)
        case nextButtonState(enableState: Bool)
        case showAlert(alert: AlertViewModel)
        case showError(error: APIResponseError)
        case setupTextField(flowType: RedemptionFlowType)
        case showActivityIndicator(show: Bool)
    }
    
    private func getConfirmAlertDescription(amount: String) -> NSAttributedString {

        let regularAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)]
        let boldAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)]

        var startString = ""
        if flowType == .OPF {
            startString = "Your amount against Voucher Number ".localized
        } else {
            startString = "The amount against PSID ".localized
        }
        let attributePart1 = NSMutableAttributedString(string: startString, attributes: regularAttributes)
        let attributePart2 = NSMutableAttributedString(string: "\n\(psidText ?? "") ", attributes: boldAttributes)
        let attributePart3 = NSMutableAttributedString(string: "is ", attributes: regularAttributes)
        var attributePart4 = NSMutableAttributedString(string: "PKR\n\(amount)", attributes: boldAttributes)
        var attributePart5 = NSMutableAttributedString(string: ". Confirm amount for Redemption?".localized, attributes: regularAttributes)
        
        if flowType == .OPF {
            attributePart4 = NSMutableAttributedString(string: "\(amount) ", attributes: boldAttributes)
            attributePart5 = NSMutableAttributedString(string: "Ponits. Confirm to redeem points at ", attributes: regularAttributes)
        }
        
        let alertDesctiption = NSMutableAttributedString()
        alertDesctiption.append(attributePart1)
        alertDesctiption.append(attributePart2)
        alertDesctiption.append(attributePart3)
        alertDesctiption.append(attributePart4)
        alertDesctiption.append(attributePart5)
        if flowType == .OPF {
            let attributePart6 = NSMutableAttributedString(string: "OPF", attributes: boldAttributes)
            alertDesctiption.append(attributePart6)
        }

        return alertDesctiption
    }
    
    private func navigateToOTPFlow(amount: String) {
        output?(.showActivityIndicator(show: true))
        let pointStr = String(category?.pointsAssigned ?? 0)
        let point = PointsFormatter().format(string: pointStr)
        
        
        
        let newInputModel: InitRedemptionTransactionModel
        if let _ = category?.categoryName {
            newInputModel = InitRedemptionTransactionModel(code: self.partner.partnerName, pse: self.partner.partnerName, consumerNo: self.psidText, amount: amount, sotp: 1, pseChild: category?.categoryName ?? "", point: point)
        } else {
            newInputModel = InitRedemptionTransactionModel(code: partner.partnerName, pse: partner.partnerName, consumerNo: psidText, amount: amount, sotp: 1)
        }
        
        self.service.redemptionTransactionSendOTP(requestModel: newInputModel) { result in
            self.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let model):
                print(model)
                self.router.navigateToOTPScreen(transactionID: model.transactionId, partner: self.partner, user: self.user, inputModel: newInputModel, flowType: self.flowType)
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        }
    }
    
}

extension RedemptionPSIDViewModel {
    private func validateTextFields() {
        if flowType == .OPF {
            if psidText?.isEmpty ?? false {
                output?(.nextButtonState(enableState: false))
            } else {
                output?(.nextButtonState(enableState: true))
            }
        } else {
            if psidText?.isEmpty ?? false || psidText?.count ?? 0 < 24 {
                output?(.nextButtonState(enableState: false))
            } else {
                output?(.nextButtonState(enableState: true))
            }
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

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
        
        if flowType == .BEOE {
            navigateToOTPFlow(amount: String(category?.pointsAssigned ?? 0))
        } else {
        
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
                    var topTextField: AlertTextFieldModel? = AlertTextFieldModel(titleLabelText: nil, placeholderText: "Enter other Amount Here".localized, inputText: nil, inputFieldMaxLength: 13, inputFieldMinLength: nil, editKeyboardType: .decimalPad, formatValidator: FormatValidator(regex: RegexConstants.transactionAmountRegex, invalidFormatError: StringConstants.ErrorString.transactionAmountError.localized), formatter: TransactionAmountFormatter()) { text in
                        amount = text
                    }
                    let cancelButton = AlertActionButtonModel(buttonTitle: "Cancel".localized, buttonAction: nil)
                    let confirmButton = AlertActionButtonModel(buttonTitle: "Confirm".localized, buttonAction: { [weak self] in
                        
                        guard let self = self else { return }
                        if self.checkAmount(amount: amount, responseModel: model.billInquiryResponse) {
                            let alert: AlertViewModel
                            alert = AlertViewModel(alertHeadingImage: .noImage, alertTitle: "Error", alertDescription: "Amount can not be more than \(model.billInquiryResponse.amount) and lesser than 0", primaryButton: AlertActionButtonModel(buttonTitle: "OK".localized))
                            self.output?(.showAlert(alert: alert))
                        } else {
                            self.navigateToOTPFlow(amount: amount)
                        }
                    })
                    topTextField = self?.flowType == .FBR || self?.flowType == .OPF || self?.flowType == .BEOE || self?.flowType == .PIA ? nil : topTextField
                    if self?.flowType == .SLIC {
                        if self?.category?.categoryName.lowercased().contains("loan".lowercased()) ?? false {
                           
                        } else {
                            topTextField = nil
                        }
                    }
                    alert = AlertViewModel(alertHeadingImage: .redeemPoints, alertTitle: "Redeem Points".localized, alertDescription: nil, alertAttributedDescription: self?.getConfirmAlertDescription(amount: amount), primaryButton: confirmButton, secondaryButton: cancelButton, topTextField: topTextField)
                    self?.output?(.showAlert(alert: alert))
                case .failure(let error):
                    self?.output?(.showError(error: error))
                }
            }
        }
    }
    
    func cancelButtonPressed() {
        router.navigateBack()
    }
    
    func viewDidLoad() {
        output?(.updateLoyaltyPoints(viewModel: LoyaltyCardViewModel(with: user.loyaltyLevel, userPoints: "\(user.roundedLoyaltyPoints)", user: self.user)))
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
        } else if flowType == .SLIC {
            startString = "The amount against Policy No. ".localized
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
            attributePart5 = NSMutableAttributedString(string: "Points. Confirm to redeem points at ", attributes: regularAttributes)
        } else if flowType == .SLIC {
            attributePart4 = NSMutableAttributedString(string: "PKR\n\(amount).", attributes: boldAttributes)
            attributePart5 = NSMutableAttributedString(string: "\nConfirm amount to Redeem Points at ".localized, attributes: regularAttributes)
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
        } else if flowType == .SLIC {
            let attributePart6 = NSMutableAttributedString(string: "State\nLife?", attributes: boldAttributes)
            alertDesctiption.append(attributePart6)
            
        }
        
        if flowType == .BEOE {
            let newAlertDescription = NSMutableAttributedString()
            let attribute1 = NSMutableAttributedString(string: "You have selected to redeem ", attributes: regularAttributes)
            let attribute2 = NSMutableAttributedString(string: "\(amount) ", attributes: boldAttributes)
            let attribute3 = NSMutableAttributedString(string: "points\nfor ", attributes: regularAttributes)
            let attribute4 = NSMutableAttributedString(string: "\(category?.categoryName ?? "") ", attributes: boldAttributes)
            let attribute5 = NSMutableAttributedString(string: "at Bureau\nof Emigration & Overseas Employment", attributes: regularAttributes)
            newAlertDescription.append(attribute1)
            newAlertDescription.append(attribute2)
            newAlertDescription.append(attribute3)
            newAlertDescription.append(attribute4)
            newAlertDescription.append(attribute5)
            return newAlertDescription
        } else {
            return alertDesctiption
        }
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
    
    private func checkAmount(amount: String, responseModel: BillInquiryResponseModel) -> Bool {
        let intAmount = Int(amount) ?? 0
        let intResponseAmount = Int(responseModel.amount) ?? 0
                
        if flowType == .SLIC {
            if intAmount < 0 {
                return true
            }
        } else {
            if intAmount > intResponseAmount || intAmount < 0 {
                return true
            }
        }
        return false
    }
    
}

extension RedemptionPSIDViewModel {
    private func validateTextFields() {
        if flowType == .BEOE {
            if psidText?.isEmpty ?? false || psidText?.count ?? 0 < 13 {
                output?(.nextButtonState(enableState: false))
            } else {
                output?(.nextButtonState(enableState: true))
            }
        } else if flowType == .OPF {
            if psidText?.isEmpty ?? false || psidText?.count ?? 0 > 24 || psidText?.count ?? 0 < 1 {
                output?(.nextButtonState(enableState: false))
            } else {
                output?(.nextButtonState(enableState: true))
            }
        } else {
            if psidText?.isEmpty ?? false || psidText?.count ?? 0 > 24 || psidText?.count ?? 0 < 8 || !(psidText?.isValid(for: RegexConstants.alphanuericRegex) ?? false) {
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

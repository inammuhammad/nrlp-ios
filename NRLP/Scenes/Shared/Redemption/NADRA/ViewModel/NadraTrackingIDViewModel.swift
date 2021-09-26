//
//  NadraTrackingIDViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 21/09/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias NadraTrackingIDViewModelOutput = (NadraTrackingIDViewModel.Output) -> Void

protocol NadraTrackingIDViewModelProtocol {
    var output: NadraTrackingIDViewModelOutput? { get set }
    var trackingID: String? { get set }
    var cnic: String? { get set }
    func nextButtonPressed()
    func cancelButtonPressed()
    func viewDidLoad()
}

class NadraTrackingIDViewModel: NadraTrackingIDViewModelProtocol {
    var trackingID: String? {
        didSet {
            validateTextFields()
        }
    }
    
    var cnic: String? {
        didSet {
            validateTextFields()
        }
    }
    
    private var router: NadraTrackingIDRouter
    private var user: UserModel
    private var flowType: RedemptionFlowType
    private var partner: Partner
    private var category: Category
    private var service: RedemptionService
    
    var output: NadraTrackingIDViewModelOutput?
    
    init(router: NadraTrackingIDRouter, user: UserModel, flowType: RedemptionFlowType, category: Category, partner: Partner, service: RedemptionService = RedemptionService()) {
        self.router = router
        self.user = user
        self.flowType = flowType
        self.category = category
        self.partner = partner
        self.service = service
    }
    
    func nextButtonPressed() {
        output?(.showActivityIndicator(show: true))
        let points = PointsFormatter().format(string: "\(category.pointsAssigned)")
        
        let model = InitRedemptionTransactionModel(code: partner.partnerName, pse: partner.partnerName, consumerNo: cnic, trackingID: trackingID)
        service.initRedemptionTransaction(requestModel: model) { [weak self] result in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                self?.showConfirmPopup(point: points, responseModel: response, inputModel: model)
            case .failure(let error):
                self?.output?(.showError(error: error))
            }
        }
    }
    
    func cancelButtonPressed() {
        router.navigateBack()
    }
    
    func viewDidLoad() {
        output?(.updateLoyaltyPoints(viewModel: LoyaltyCardViewModel(with: user.loyaltyLevel, userPoints: "\(user.roundedLoyaltyPoints)", user: self.user)))
        output?(.nextButtonState(enableState: false))
    }
    
    enum Output {
        case updateLoyaltyPoints(viewModel: LoyaltyCardViewModel)
        case trackingIDTextField(errorState: Bool, error: String?)
        case cnicTextField(errorState: Bool, error: String?)
        case nextButtonState(enableState: Bool)
        case showAlert(alert: AlertViewModel)
        case showError(error: APIResponseError)
        case showActivityIndicator(show: Bool)
    }
    
    private func getConfirmAlertDescription(amount: String) -> NSAttributedString {

        let regularAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)]
        let boldAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)]

        let attributePart1 = NSMutableAttributedString(string: "The amount against Tracking ID: ".localized, attributes: regularAttributes)
        let attributePart2 = NSMutableAttributedString(string: "\n\(trackingID ?? "") ", attributes: boldAttributes)
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
    
    private func showConfirmPopup(point: String, responseModel: InitRedemptionTransactionResponseModel, inputModel: InitRedemptionTransactionModel) {
        let alert: AlertViewModel
        
        let cancelButton = AlertActionButtonModel(buttonTitle: "Cancel".localized, buttonAction: nil)
        let confirmButton = AlertActionButtonModel(buttonTitle: "Confirm".localized, buttonAction: { [weak self] in
            guard let self = self else { return }
            self.output?(.showActivityIndicator(show: true))
//            self.router.navigateToSuccessScreen(trackingID: self.trackingID ?? "", amount: amount, flowType: self.flowType)
            var newInputModel = inputModel
            newInputModel.sotp = 1
            newInputModel.amount = responseModel.billInquiryResponse.amount
            self.service.redemptionTransactionSendOTP(requestModel: newInputModel) { result in
                self.output?(.showActivityIndicator(show: false))
                switch result {
                case .success(let response):
                    self.router.navigateToOTPScreen(transactionID: response.transactionId, partner: self.partner, user: self.user, inputModel: newInputModel, flowType: self.flowType)
                case .failure(let error):
                    self.output?(.showError(error: error))
                }
            }
            
        })
        alert = AlertViewModel(alertHeadingImage: .redeemPoints, alertTitle: "Redeem Points".localized, alertDescription: nil, alertAttributedDescription: getConfirmAlertDescription(amount: responseModel.billInquiryResponse.amount), primaryButton: confirmButton, secondaryButton: cancelButton)
        output?(.showAlert(alert: alert))
    }
}

extension NadraTrackingIDViewModel {
    private func validateTextFields() {
        if trackingID?.isEmpty ?? false || cnic?.isEmpty ?? false || trackingID == nil || cnic == nil || trackingID?.count ?? 0 != 12 || cnic?.count ?? 0 != 13 {
            output?(.nextButtonState(enableState: false))
        } else {
            output?(.nextButtonState(enableState: true))
        }
    }
}

//
//  TransferPointsViewModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 14/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias TransferPointsViewModelOutput = (TransferPointsViewModel.Output) -> Void

protocol TransferPointsViewModelProtocol {
    var output: TransferPointsViewModelOutput? { get set}
    var beneficiaryPickerViewModel: ItemPickerViewModel { get }
    var beneficiary: BeneficiaryModel? { get set }
    var transferPoints: String? { get set }
    var beneficiaryItems: [BeneficiaryPickerItemModel] { get }
    func didTapTransferButton()
    func didSelect(beneficiaryItem: BeneficiaryPickerItemModel?)
    func viewModelWillAppear()
}

class TransferPointsViewModel: TransferPointsViewModelProtocol {
    private var user: UserModel
    
    private(set) var beneficiaryItems: [BeneficiaryPickerItemModel] = [] {
        didSet {
            output?(.showNoBeneficiary(show: !self.beneficiaryItems.isEmpty))
        }
    }

    var beneficiaryPickerViewModel: ItemPickerViewModel {
        return ItemPickerViewModel(data: beneficiaryItems)
    }

    var transferPoints: String? {
        didSet {
            validateRequiredFields()
        }
    }

    var beneficiary: BeneficiaryModel? {
        didSet {
            validateRequiredFields()
        }
    }

    private var loyaltyPoints: String?
    private var router: TransferPointsRouter?
    var output: TransferPointsViewModelOutput?
    private var service: ManageBeneficiaryServiceProtocol?
    private var loyaltyPointService: LoyaltyPointsServiceProtocol?
    
    init(with router: TransferPointsRouter,
         user: UserModel,
         service: ManageBeneficiaryServiceProtocol = ManageBeneficiaryService(),
         loyaltyPointService: LoyaltyPointsServiceProtocol = LoyaltyPointsService()) {
        self.router = router
        self.service = service
        self.user = user
        self.loyaltyPointService = loyaltyPointService
    }

    func viewModelWillAppear() {
        self.fetchBeneficiary()
        self.formatPoints()
    }

    private func formatPoints() {
        let formater = PointsFormatter()
        let formattedNumber = formater.format(string: "\(user.roundedLoyaltyPoints)")
        output?(.updateLoyaltyCard(viewModel: LoyaltyCardViewModel(with: user.loyaltyLevel, userPoints: formattedNumber, user: self.user)))
    }

    func didSelect(beneficiaryItem: BeneficiaryPickerItemModel?) {
        self.beneficiary = beneficiaryItem?.beneficiary
        output?(.updateBeneficiary(beneficiary: beneficiary?.alias ?? "Name".localized))
    }

    private func getConfirmAlertDescription() -> NSAttributedString {

        let formattedPoints = PointsFormatter().format(string: self.transferPoints ?? "")
        let regularAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)]
        let boldAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)]

        let attributePart1 = NSMutableAttributedString(string: "Are you sure you want to transfer ".localized, attributes: regularAttributes)
        let attributePart2 = NSMutableAttributedString(string: "\(formattedPoints) ", attributes: boldAttributes)
        let attributePart3 = NSMutableAttributedString(string: "\nPoints to ".localized, attributes: regularAttributes)
        let attributePart4 = NSMutableAttributedString(string: "\(beneficiary?.alias ?? "") ", attributes: boldAttributes)
        let attributePart5 = NSMutableAttributedString(string: "points_transfer_end".localized, attributes: regularAttributes)

        let alertDesctiption = NSMutableAttributedString()
        alertDesctiption.append(attributePart1)
        alertDesctiption.append(attributePart2)
        alertDesctiption.append(attributePart3)
        alertDesctiption.append(attributePart4)
        alertDesctiption.append(attributePart5)

        return alertDesctiption
    }

    func didTapTransferButton() {
        if !validateDataWithRegex() {
            return
        }

        let alert: AlertViewModel

        if Int64(transferPoints ?? "0") ?? Int64.max > Int64(user.roundedLoyaltyPoints) {

            let okButton = AlertActionButtonModel(buttonTitle: "Okay".localized, buttonAction: nil)
            alert = AlertViewModel(alertHeadingImage: .ohSnap, alertTitle: "Oh Snap!".localized, alertDescription: StringConstants.ErrorString.notEnoughtFundToTransfer.localized.localized, primaryButton: okButton)

        } else {

            let cancelButton = AlertActionButtonModel(buttonTitle: "Cancel".localized, buttonAction: nil)
            let confirmButton = AlertActionButtonModel(buttonTitle: "Confirm".localized, buttonAction: { [weak self] in

                guard let self = self else { return }
                self.performPointsTransfer()
            })

            alert = AlertViewModel(alertHeadingImage: .transferPointAlert, alertTitle: "Transfer Points".localized, alertDescription: nil, alertAttributedDescription: getConfirmAlertDescription(), primaryButton: confirmButton, secondaryButton: cancelButton)
        }

        output?(.showAlert(alert: alert))
    }

    private func performPointsTransfer() {
            self.output?(.showActivityIndicator(show: true))

            self.loyaltyPointService?.transferLoyaltyPoints(requestModel: LoyaltyPointsRequestModel(beneficiaryId: Int(self.beneficiary!.beneficiaryId), points: self.transferPoints ?? "0" )) { [weak self] (result) in

                guard let self = self else { return }
                self.output?(.showActivityIndicator(show: false))
                switch result {
                case .success:
                    self.router?.navigateToSuccessScreen(points: self.transferPoints ?? "0", beneficiary: self.beneficiary!)
                case .failure(let error):
                    self.output?(.showError(error: error))
                }
            }
    }

    private func fetchBeneficiary() {

        output?(.showActivityIndicator(show: true))
        guard let accountType = user.accountType else { return }
        service?.fetchBeneficiaries(requestModel: ManageBeneficiaryRequestModel(nicNicop: "\(user.cnicNicop)", accountType: accountType.rawValue)) { [weak self] (result) in

            guard let self = self else { return }
            self.output?(.showActivityIndicator(show: false))

            switch result {
            case .success(let beneficiariesResponse):
                self.processBeneficiary(serviceResponse: beneficiariesResponse)
                self.output?(.reloadBeneficiaries)
            case .failure(let error):
                self.output?(.showError(error: error))
                self.beneficiaryItems = []
            }
        }
    }

    private func processBeneficiary(serviceResponse: ManageBeneficiaryResponseModel) {
        self.beneficiaryItems = serviceResponse.data.filter({
            $0.isActive == 0 ? false : true
        }).compactMap({
            BeneficiaryPickerItemModel(title: $0.alias ?? "", key: "\($0.beneficiaryId)", beneficiary: $0)
        })
    }

    enum Output {
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case nextButtonState(enableState: Bool)
        case updateBeneficiary(beneficiary: String)
        case transferPointsTextField(errorState: Bool, error: String?)
        case beneficiaryTextField(errorState: Bool, error: String?)
        case showAlert(alert: AlertViewModel)
        case reloadBeneficiaries
        case updateLoyaltyCard(viewModel: LoyaltyCardViewModel)
        case showNoBeneficiary(show: Bool)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }

}

extension TransferPointsViewModel {
    private func validateRequiredFields() {
        if transferPoints?.isBlank ?? true || beneficiary == nil || transferPoints?.int ?? 0 <= 0 {
            output?(.nextButtonState(enableState: false))
        } else {
            output?(.nextButtonState(enableState: true))
        }
        if !(transferPoints?.isBlank ?? true) && transferPoints?.int ?? 0 <= 0 {
            output?(.transferPointsTextField(errorState: true, error: StringConstants.ErrorString.loyaltyPointsError.localized))
        }
    }

    private func validateDataWithRegex() -> Bool {
        var isValid: Bool = true

        if transferPoints != "0" && transferPoints?.isValid(for: RegexConstants.transactionAmountRegex) ?? false {
            output?(.transferPointsTextField(errorState: false, error: nil))
        } else {
            output?(.transferPointsTextField(errorState: true, error: StringConstants.ErrorString.loyaltyPointsError.localized))
            isValid = false
        }

        if beneficiary != nil {
            output?(.beneficiaryTextField(errorState: false, error: nil))
        } else {
            output?(.beneficiaryTextField(errorState: true, error: StringConstants.ErrorString.beneficiarySelectError.localized))
        }

        return isValid
    }
}

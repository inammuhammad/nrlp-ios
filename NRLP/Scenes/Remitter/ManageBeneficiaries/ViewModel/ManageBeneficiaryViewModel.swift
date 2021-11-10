//
//  ManageBeneficiaryViewModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
typealias ManageBeneficiaryViewModelOutput = (ManageBeneficiaryViewModel.Output) -> Void

protocol ManageBeneficiaryViewModelProtocol {
    var output: ManageBeneficiaryViewModelOutput? { get set }
    var numberOfRows: Int { get }

    func viewModelWillAppear()
    func getBeneficiary(at index: Int) -> BeneficiaryModel
    func didSelectedBeneficiary(indexPath: IndexPath)
    func addBeneficiaryClicked()
}

class ManageBeneficiaryViewModel: ManageBeneficiaryViewModelProtocol {

    var output: ManageBeneficiaryViewModelOutput?
    private var router: ManageBeneficiaryRouter!
    private var manageBeneficiaryService: ManageBeneficiaryServiceProtocol!
    private var user: UserModel

    private var beneficiaries: [BeneficiaryModel] = []

    init(with service: ManageBeneficiaryServiceProtocol = ManageBeneficiaryService(),
         router: ManageBeneficiaryRouter, user: UserModel) {
        self.manageBeneficiaryService = service
        self.router = router
        self.user = user
    }

    func viewModelWillAppear() {
        fetchBeneficiaries()
    }

    private func fetchBeneficiaries() {

        output?(.showActivityIndicator(show: true))

        manageBeneficiaryService.fetchBeneficiaries(requestModel: ManageBeneficiaryRequestModel(nicNicop: "\(user.cnicNicop)", accountType: user.accountType?.getTitle() ?? "")) { [weak self] (result) in

            guard let self = self else { return }
            self.output?(.showActivityIndicator(show: false))

            switch result {
            case .success(let beneficiariesResponse):
                self.beneficiaries = beneficiariesResponse.data
                self.output?(.reloadBeneficiaries)
                if !self.beneficiaries.isEmpty {
                    self.output?(.tableVisibility(show: true ))
                } else {
                    self.output?(.tableVisibility(show: false ))
                }

                if self.beneficiaries.count >= NRLPUserDefaults.shared.getMaxBeneficiariesAllowed() ?? 3 {
                    self.output?(.addButton(state: false))
                } else {
                    self.output?(.addButton(state: true))
                }
            case .failure(let error):
                self.output?(.showError(error: error))
                self.output?(.tableVisibility(show: false ))
            }
        }
    }

    func didSelectedBeneficiary(indexPath: IndexPath) {
        router.moveToInfoScreen(beneficiary: getBeneficiary(at: indexPath.row), service: self.manageBeneficiaryService)
    }

    func addBeneficiaryClicked() {
        router.moveToAddScreen()
    }

    enum Output {
        case showError(error: APIResponseError)
        case showActivityIndicator(show: Bool)
        case reloadBeneficiaries
        case tableVisibility(show: Bool)
        case addButton(state: Bool)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

// MARK: DataSource related methods
extension ManageBeneficiaryViewModel {
    var numberOfRows: Int {
        return beneficiaries.count
    }

    func getBeneficiary(at index: Int) -> BeneficiaryModel {
        return beneficiaries[index]
    }
}

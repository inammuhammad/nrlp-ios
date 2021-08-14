//
//  BeneficiaryInfoViewMode.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
typealias BeneficiaryInfoViewModelOutput = (BeneficiaryInfoViewModel.Output) -> Void

protocol BeneficiaryInfoViewModelProtocol {
    var output: BeneficiaryInfoViewModelOutput? { get set}
    var name: String? { get set }
    var cnic: String? { get set }
    var mobileNumber: String? { get set }
    
    func deleteButtonPressed()
    
}

class BeneficiaryInfoViewModel: BeneficiaryInfoViewModelProtocol {
    
    var output: BeneficiaryInfoViewModelOutput?
    private var router: BeneficiaryInfoRouter
    private var service: ManageBeneficiaryServiceProtocol
    private var beneficiary: BeneficiaryModel
    
    var name: String?
    var cnic: String?
    var mobileNumber: String?
    
    init(router: BeneficiaryInfoRouter, beneficiary: BeneficiaryModel, service: ManageBeneficiaryServiceProtocol) {
        self.router = router
        self.beneficiary = beneficiary
        self.service = service
        self.name = beneficiary.alias
        self.cnic = "\(beneficiary.nicNicop)"
        self.mobileNumber = beneficiary.mobileNo
    }
    
    func deleteButtonPressed() {
        
        let descriptionString = String(format: "Are you sure you want to delete %@ ?".localized, beneficiary.alias ?? "")
        let model = AlertViewModel(alertHeadingImage: .declineAlert, alertTitle: "Delete Beneficiary".localized, alertDescription: descriptionString, primaryButton: AlertActionButtonModel(buttonTitle: "Yes".localized, buttonAction: {
            self.output?(.showActivityIndicator(show: true))
            self.service.deleteBeneficiary(beneficiary: DeleteBeneficiaryRequestModel( beneficiaryId: self.beneficiary.beneficiaryId)) { [weak self] (result) in
                self?.output?(.showActivityIndicator(show: false))
                guard let self = self else { return }
                self.output?(.showActivityIndicator(show: false))
                
                switch result {
                case .success:
                    self.router.popToBeneficiaryInfoController()
                case .failure(let error):
                    self.output?(.showError(error: error))
                }
                
            }
            
        }), secondaryButton: AlertActionButtonModel(buttonTitle: "No".localized, buttonAction: {
            
        }))
        
        self.output?(.showAlert(alert: model))
        
    }
    
    enum Output {
        case showError(error: APIResponseError)
        case deleteButtonState
        case showAlert(alert: AlertViewModel)
        case dismissAlert
        case showActivityIndicator(show: Bool)
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

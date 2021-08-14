//
//  BenefitsViewModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 13/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias BenefitsViewModelOutput = (BenefitsViewModel.Output) -> Void

protocol BenefitsViewModelProtocol {
    var output: BenefitsViewModelOutput? {get set}
    var numberOfRows: Int {get}
    func didSelectOption(index: Int)
    func viewWillAppear()
    func getPartner(index: Int) -> NRLPPartners
}

class BenefitsViewModel: BenefitsViewModelProtocol {
    
    private var router: BenefitsRouter!
    var output: BenefitsViewModelOutput?
    private var service: NRLPBenefitsServiceProtocol
    private var partners: [NRLPPartners] = []
    
    var numberOfRows: Int {
        return partners.count
    }
    
    init(router: BenefitsRouter,
         service: NRLPBenefitsServiceProtocol = NRLPBenefitsService()) {
        self.router = router
        self.service = service
    }
    
    func didSelectOption(index: Int) {
        router.navigateToCategory(partner: partners[index])
    }
    
    func viewWillAppear() {
        fetchLoyaltyPartners()
    }
    
    func getPartner(index: Int) -> NRLPPartners {
        return partners[index]
    }
    
    private func fetchLoyaltyPartners() {
        self.output?(.showActivityIndicator(show: true))
        service.fetchNRLPBenefits {[weak self] (result) in
            self?.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let response):
                self?.partners = response.data.redemptionPartners
                self?.output?(.dataReload)
            case .failure(let error):
                self?.output?(.showError(error: error))
            }
        }
    }
    
    enum Output {
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case dataReload
    }
}

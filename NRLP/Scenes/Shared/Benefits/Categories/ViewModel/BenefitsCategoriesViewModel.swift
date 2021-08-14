//
//  BenefitsCategoriesViewModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 14/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias BenefitsCategoriesViewModelOutput = (BenefitsCategoriesViewModel.Output) -> Void

protocol BenefitsCategoriesViewModelProtocol {
    var output: BenefitsCategoriesViewModelOutput? {get set}
    var numberOfRows: Int {get}
    func viewDidLoad()
    func getCategory(index: Int) -> NRLPBenefitCategory
}

class BenefitsCategoriesViewModel: BenefitsCategoriesViewModelProtocol {
    
    private var router: BenefitsCategoriesRouter!
    var output: BenefitsCategoriesViewModelOutput?
    private var partner: NRLPPartners!
    private var service: NRLPBenefitsServiceProtocol!
    
    private var categories: [NRLPBenefitCategory] = []
    var numberOfRows: Int {
        return categories.count
    }
    
    init(router: BenefitsCategoriesRouter,
         partner: NRLPPartners,
         service: NRLPBenefitsServiceProtocol = NRLPBenefitsService()) {
        self.router = router
        self.partner = partner
        self.service = service
    }
    
    func viewDidLoad() {
        fetchCategories()
        output?(.updateView(partner: partner))
    }
    
    func getCategory(index: Int) -> NRLPBenefitCategory {
        return categories[index]
    }
    
    func fetchCategories() {
        output?(.showActivityIndicator(show: true))
        service.fetchNRLPBenefitsCategory(for: partner) { [weak self] (response) in
            guard let self = self else { return }
            self.output?(.showActivityIndicator(show: false))
            switch response {
            case .success(let response):
                self.categories = response.data.partnerCatalogs
                self.output?(.dataReload)
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        }
    }
    
    enum Output {
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case dataReload
        case updateView(partner: NRLPPartners)
    }
}

//
//  NRLPBenefitsServiceMock.swift
//  NRLPTests
//
//  Created by VenD on 22/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class NRLPBenefitsServicePositiveMock: NRLPBenefitsServiceProtocol {
    func fetchNRLPBenefits(completion: @escaping NRLPBenefitsServiceCallBack) {
        completion(.success(NRLPBenefitResponseModel(message: "success", data: RedemptionPartners(redemptionPartners: [getNRLPPartners(), getNRLPPartners()]))))
    }
    
    func fetchNRLPBenefitsCategory(for partner: NRLPPartners, completion: @escaping NRLPBenefitsCategoryServiceCallBack) {
        completion(.success(NRLPBenefitCategoryResponseModel(message: "success", data: NRLPBenefitPartnerCatalog(partnerCatalogs: [NRLPBenefitCategory(name: "urgent")]))))
    }
}

class NRLPBenefitsServiceNegativeMock: NRLPBenefitsServiceProtocol {
    func fetchNRLPBenefits(completion: @escaping NRLPBenefitsServiceCallBack) {
        completion(.failure(.internetOffline))
    }
    
    func fetchNRLPBenefitsCategory(for partner: NRLPPartners, completion: @escaping NRLPBenefitsCategoryServiceCallBack) {
        completion(.failure(.internetOffline))
    }
}

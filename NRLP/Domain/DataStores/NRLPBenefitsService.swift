//
//  NRLPBenefitsService.swift
//  NRLP
//
//  Created by VenD on 02/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias NRLPBenefitsServiceCallBack = (Result<NRLPBenefitResponseModel, APIResponseError>) -> Void
typealias NRLPBenefitsCategoryServiceCallBack = (Result<NRLPBenefitCategoryResponseModel, APIResponseError>) -> Void

protocol NRLPBenefitsServiceProtocol {

    func fetchNRLPBenefits(completion: @escaping NRLPBenefitsServiceCallBack)
    func fetchNRLPBenefitsCategory(for partner: NRLPPartners, completion: @escaping NRLPBenefitsCategoryServiceCallBack)
}

class NRLPBenefitsService: BaseDataStore, NRLPBenefitsServiceProtocol {
    func fetchNRLPBenefits(completion: @escaping NRLPBenefitsServiceCallBack) {

        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }

        // request building
        let request = RequestBuilder(path: .init(endPoint: .nrlpBenefits), parameters: EmptyModel(), shouldHash: false)
        networking.get(request: request) { (response: APIResponse<NRLPBenefitResponseModel>) in
            completion(response.result)
        }
    }
    
    func fetchNRLPBenefitsCategory(for partner: NRLPPartners, completion: @escaping NRLPBenefitsCategoryServiceCallBack) {

        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }

        // request building
        let request = RequestBuilder(path: .init(endPoint: .nrlpBenefit(partnerId: "\(partner.id)")), parameters: EmptyModel())
        networking.get(request: request) { (response: APIResponse<NRLPBenefitCategoryResponseModel>) in
            completion(response.result)
        }
    }
}

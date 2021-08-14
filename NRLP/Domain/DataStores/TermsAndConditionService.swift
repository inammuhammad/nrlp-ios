//
//  TermsAndConditionService.swift
//  1Link-NRLP
//
//  Created by VenD on 10/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias TermsAndConditionServiceCallBack = (Result<TermsAndConditionResponseModel, APIResponseError>) -> Void

protocol TermsAndConditionServiceProtocol {

    func fetchTermsAndCondition(requestModel: TermsAndConditionRequestModel, completion: @escaping TermsAndConditionServiceCallBack)
}

extension TermsAndConditionServiceProtocol {
    func fetchTermsAndCondition(completion: @escaping TermsAndConditionServiceCallBack) {
        fetchTermsAndCondition(requestModel: TermsAndConditionRequestModel(), completion: completion)
    }
}

class TermsAndConditionService: BaseDataStore, TermsAndConditionServiceProtocol {
    func fetchTermsAndCondition(requestModel: TermsAndConditionRequestModel, completion: @escaping TermsAndConditionServiceCallBack) {

        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }
//        let content = TermsAndConditionContentModel(content: StringConstants.termsAndCondition)

    //    completion(.success(TermsAndConditionResponseModel(message: "Success", data: content)))

        // request building
        let request = RequestBuilder(path: .init(endPoint: .termsAndCondition), parameters: requestModel, shouldHash: false)

        networking.get(request: request) { (response: APIResponse<TermsAndConditionResponseModel>) in

            completion(response.result)
        }
    }
}

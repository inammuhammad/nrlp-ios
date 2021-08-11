//
//  TermsAndConditionService.swift
//  1Link-NRLP
//
//  Created by VenD on 10/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class TermsAndConditionServicePositiveMock: TermsAndConditionServiceProtocol {
    func fetchTermsAndCondition(requestModel: TermsAndConditionRequestModel, completion: @escaping TermsAndConditionServiceCallBack) {
        let content = TermsAndConditionContentModel(content: StringConstants.termsAndCondition)
        completion(.success(TermsAndConditionResponseModel(message: "Success", data: content)))
    }
}

class TermsAndConditionServiceNegativeMock: TermsAndConditionServiceProtocol {
    func fetchTermsAndCondition(requestModel: TermsAndConditionRequestModel, completion: @escaping TermsAndConditionServiceCallBack) {
        completion(.failure(.internetOffline))
    }
}

//
//  CSRService.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 09/06/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import Foundation

typealias CSRCallback = (Result<CSRResponseModel, APIResponseError>) -> Void
typealias RegistrationCSRCallback = (Result<RegistrationCSRResponseModel, APIResponseError>) -> Void

protocol CSRServiceProtocol {
    func submitRating(requestModel: CSRRequestModel, responseHandler: @escaping CSRCallback)
    func submitRegistrationRating(requestModel: RegistrationCSRRequestModel, responseHandler: @escaping RegistrationCSRCallback)
}

class CSRService: BaseDataStore, CSRServiceProtocol {
    func submitRating(requestModel: CSRRequestModel, responseHandler: @escaping CSRCallback) {
        let request = RequestBuilder(path: APIPathBuilder(endPoint: .customerSatisfactionRating), parameters: requestModel)
        networking.post(request: request) { (response: APIResponse<CSRResponseModel>) in
            responseHandler(response.result)
        }
    }
    
    func submitRegistrationRating(requestModel: RegistrationCSRRequestModel, responseHandler: @escaping RegistrationCSRCallback) {
        let request = RequestBuilder(path: APIPathBuilder(endPoint: .registrationRating), parameters: requestModel)
        networking.post(request: request) { (response: APIResponse<RegistrationCSRResponseModel>) in
            responseHandler(response.result)
        }
    }
}

//
//  SelfAwardOTPService.swift
//  NRLP
//
//  Created by Bilal Iqbal on 29/08/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

typealias SelfAwardOTPValidateServiceCompletionHandler = (Result<SelfAwardValidateResponseModel, APIResponseError>) -> Void
typealias SelfAwardValidateTransactionServiceCompletionHandler = (Result<SelfAwardValidateOTPResponseModel, APIResponseError>) -> Void

protocol SelfAwardOTPServiceProtocol {

    func validateTransaction(requestModel: SelfAwardModel, responseHandler: @escaping SelfAwardOTPValidateServiceCompletionHandler)
    func verifyOTP(requestModel: SelfAwardVerifyOTPRequestModel, responseHandler: @escaping SelfAwardValidateTransactionServiceCompletionHandler)
}

class SelfAwardOTPService: BaseDataStore, SelfAwardOTPServiceProtocol {
    
    func validateTransaction(requestModel: SelfAwardModel, responseHandler: @escaping SelfAwardOTPValidateServiceCompletionHandler) {
        let request = RequestBuilder(path: .init(endPoint: .selfAwardValidateTransaction), parameters: requestModel, shouldHash: true)
        networking.post(request: request) { (response: APIResponse<SelfAwardValidateResponseModel>) in
            responseHandler(response.result)
        }
    }
    
    func verifyOTP(requestModel: SelfAwardVerifyOTPRequestModel, responseHandler: @escaping SelfAwardValidateTransactionServiceCompletionHandler) {
        let request = RequestBuilder(path: .init(endPoint: .selfAwardVerifyOTP), parameters: requestModel, shouldHash: true)
        networking.post(request: request) { (response: APIResponse<SelfAwardValidateOTPResponseModel>) in
            responseHandler(response.result)
        }
    }

}

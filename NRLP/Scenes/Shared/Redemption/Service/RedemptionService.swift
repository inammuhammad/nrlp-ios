//
//  RedemptionService.swift
//  NRLP
//
//  Created by Bilal Iqbal on 24/09/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

typealias InitRedemptionTransactionCompletionHandler = (Result<InitRedemptionTransactionResponseModel, APIResponseError>) -> Void
typealias RedemptionTransactionSendOTPCompletionHandler = (Result<RedemptionTransactionSendOTPResponseModel, APIResponseError>) -> Void
typealias RedemptionVerifyOTPCompletionHandler = (Result<RedeemVerifyOTPResponseModel, APIResponseError>) -> Void
typealias CompleteRedemptionCompletionHandler = (Result<RedeemCompleteResponseModel, APIResponseError>) -> Void


protocol RedemptionServiceProtocol {

    func initRedemptionTransaction(requestModel: InitRedemptionTransactionModel, responseHandler: @escaping InitRedemptionTransactionCompletionHandler)
    func redemptionTransactionSendOTP(requestModel: InitRedemptionTransactionModel, responseHandler: @escaping RedemptionTransactionSendOTPCompletionHandler)
    func redemptionTransactionVerifyOTP(requestModel: RedeemVerifyOTPRequestModel, responseHandler: @escaping RedemptionVerifyOTPCompletionHandler)
    func resendOTP(requestModel: RedeemResentOTPRequestModel, responseHandler: @escaping RedemptionVerifyOTPCompletionHandler)
    func completeRedemptionTransaction(requestModel: CompletedRedemptionTransactionModel, responseHandler: @escaping CompleteRedemptionCompletionHandler)
}

class RedemptionService: BaseDataStore, RedemptionServiceProtocol {
    
    func initRedemptionTransaction(requestModel: InitRedemptionTransactionModel, responseHandler: @escaping InitRedemptionTransactionCompletionHandler) {
        let request = RequestBuilder(path: .init(endPoint: .initRedemptionTransaction), parameters: requestModel, shouldHash: true)
        networking.post(request: request) { (response: APIResponse<InitRedemptionTransactionResponseModel>) in
            responseHandler(response.result)
        }
    }
    
    func redemptionTransactionSendOTP(requestModel: InitRedemptionTransactionModel, responseHandler: @escaping RedemptionTransactionSendOTPCompletionHandler) {
        let request = RequestBuilder(path: .init(endPoint: .initRedemptionTransaction), parameters: requestModel, shouldHash: true)
        networking.post(request: request) { (response: APIResponse<RedemptionTransactionSendOTPResponseModel>) in
            responseHandler(response.result)
        }
    }
    
    func redemptionTransactionVerifyOTP(requestModel: RedeemVerifyOTPRequestModel, responseHandler: @escaping RedeemLoyaltyOTPCallback) {
        let request = RequestBuilder(path: APIPathBuilder(endPoint: .redeemVerifyOTP), parameters: requestModel, shouldHash: true)
        networking.post(request: request) { (response: APIResponse<RedeemVerifyOTPResponseModel>) in
            responseHandler(response.result)
        }
    }
    
    func completeRedemptionTransaction(requestModel: CompletedRedemptionTransactionModel, responseHandler: @escaping CompleteRedemptionCompletionHandler) {
        let request = RequestBuilder(path: APIPathBuilder(endPoint: .completeRedemptionTransaction), parameters: requestModel, shouldHash: true)
        networking.post(request: request) { (response: APIResponse<RedeemCompleteResponseModel>) in
            responseHandler(response.result)
        }
    }
    
    func resendOTP(requestModel: RedeemResentOTPRequestModel, responseHandler: @escaping RedemptionVerifyOTPCompletionHandler) {
        let request = RequestBuilder(path: APIPathBuilder(endPoint: .resentRedeemOTP), parameters: requestModel, shouldHash: true)
        networking.post(request: request) { (response: APIResponse<RedeemVerifyOTPResponseModel>) in
            responseHandler(response.result)
        }
    }

}

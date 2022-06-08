//
//  LoyaltyPoints.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 21/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias FetchLoyaltyPointsCallBack = (Result<FetchLoyaltyStatementResponseModel, APIResponseError>) -> Void
typealias TransferLoyaltyPointsCallBack = (Result<LoyaltyPointsResponseModel, APIResponseError>) -> Void
typealias FetchAdvanceLoyaltyPointsCallBack = (Result<AdvanceLoyaltyStatementResponseModel, APIResponseError>) -> Void
typealias FetchStatementPDFCallback = (Result<Data, APIResponseError>) -> Void

protocol LoyaltyPointsServiceProtocol {

    func fetchLoyaltyStatement(requestModel: FetchLoyaltyStatementRequestModel, responseHandler: @escaping FetchLoyaltyPointsCallBack)
//     func fetchLoyaltyAdvanceStatement(requestModel: FetchLoyaltyAdvanceStatementRequestModel, responseHandler: @escaping FetchAdvanceLoyaltyPointsCallBack)
    func transferLoyaltyPoints(requestModel: LoyaltyPointsRequestModel, responseHandler: @escaping TransferLoyaltyPointsCallBack)
    
    func fetchStatementPDF(requestModel: FetchLoyaltyAdvanceStatementRequestModel, responseHandler: @escaping FetchStatementPDFCallback)
}

class LoyaltyPointsService: BaseDataStore, LoyaltyPointsServiceProtocol {

//    func fetchLoyaltyAdvanceStatement(requestModel: FetchLoyaltyAdvanceStatementRequestModel, responseHandler: @escaping FetchAdvanceLoyaltyPointsCallBack) {
//
//        let request = RequestBuilder(path: .init(endPoint: .loyaltyStatement), parameters: requestModel)
//        networking.post(request: request) { (response: APIResponse<AdvanceLoyaltyStatementResponseModel>) in
//            responseHandler(response.result)
//        }
//    }

    func fetchLoyaltyStatement(requestModel: FetchLoyaltyStatementRequestModel, responseHandler: @escaping FetchLoyaltyPointsCallBack) {
        
        let request = RequestBuilder(path: .init(endPoint: .loyaltyStatement), parameters: requestModel)
        networking.post(request: request) { (response: APIResponse<FetchLoyaltyStatementResponseModel>) in
            responseHandler(response.result)
        }
    }

    func transferLoyaltyPoints(requestModel: LoyaltyPointsRequestModel, responseHandler: @escaping TransferLoyaltyPointsCallBack) {
        
        let request = RequestBuilder(path: .init(endPoint: .transferPoints), parameters: requestModel)
        networking.post(request: request) { (response: APIResponse<LoyaltyPointsResponseModel>) in
            responseHandler(response.result)
        }
    }
    
    func fetchStatementPDF(requestModel: FetchLoyaltyAdvanceStatementRequestModel, responseHandler: @escaping FetchStatementPDFCallback) {
        
        let request = RequestBuilder(path: .init(endPoint: .loyaltyStatement), parameters: requestModel)
        
        networking.download(request: request, method: .post) { response in
            responseHandler(response.result)
        }
    }
}

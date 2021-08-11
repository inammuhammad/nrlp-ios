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

protocol LoyaltyPointsServiceProtocol {

    func fetchLoyaltyStatement(requestModel: FetchLoyaltyStatementRequestModel, responseHandler: @escaping FetchLoyaltyPointsCallBack)
    func fetchLoyaltyAdvanceStatement(requestModel: FetchLoyaltyAdvanceStatementRequestModel, responseHandler: @escaping FetchAdvanceLoyaltyPointsCallBack)
    func transferLoyaltyPoints(requestModel: LoyaltyPointsRequestModel, responseHandler: @escaping TransferLoyaltyPointsCallBack)
}

class LoyaltyPointsService: BaseDataStore, LoyaltyPointsServiceProtocol {

    func fetchLoyaltyAdvanceStatement(requestModel: FetchLoyaltyAdvanceStatementRequestModel, responseHandler: @escaping FetchAdvanceLoyaltyPointsCallBack) {
//        let responseData = LoyaltyStatementResponseData(currentpointbalance: "4100", statements: statements)
//        responseHandler(.success(FetchLoyaltyStatementResponseModel(data: responseData, message: "Response received successfully")))
        
        let request = RequestBuilder(path: .init(endPoint: .loyaltyStatement), parameters: requestModel)
        networking.post(request: request) { (response: APIResponse<AdvanceLoyaltyStatementResponseModel>) in
            responseHandler(response.result)
        }
    }

    func fetchLoyaltyStatement(requestModel: FetchLoyaltyStatementRequestModel, responseHandler: @escaping FetchLoyaltyPointsCallBack) {

//        let responseData = LoyaltyStatementResponseData(currentpointbalance: 4100, statements: statements)
//        responseHandler(.success(FetchLoyaltyStatementResponseModel(data: responseData, message: "Response received successfully")))
        
        let request = RequestBuilder(path: .init(endPoint: .loyaltyStatement), parameters: requestModel)
        networking.post(request: request) { (response: APIResponse<FetchLoyaltyStatementResponseModel>) in
            responseHandler(response.result)
        }
    }

    func transferLoyaltyPoints(requestModel: LoyaltyPointsRequestModel, responseHandler: @escaping TransferLoyaltyPointsCallBack) {
//        responseHandler(.success(LoyaltyPointsResponseModel(message: "Transferred successfully", points: "\(requestModel.points)", beneficiary: "\(requestModel.beneficiaryId)")))

        let request = RequestBuilder(path: .init(endPoint: .transferPoints), parameters: requestModel)
        networking.post(request: request) { (response: APIResponse<LoyaltyPointsResponseModel>) in
            responseHandler(response.result)
        }
    }
}

//
//  LoyaltyPointsServiceMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 20/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class LoyaltyPointsServicePositiveMock: LoyaltyPointsServiceProtocol {
    
    var statements: [Statement] = [ Statement(status: "Remittance to Ahmad", type: "Credit", points: "100000", date: "2020-07-18T07:26:24.081Z", name: "Award Points"),
    Statement(status: "Remittance to Ahmad", type: "Credit", points: "5000", date: "2020-07-18T07:26:24.081Z", name: "Award Points"),
    Statement(status: "Remittance to Ahmad", type: "Credit", points: "10000", date: "2020-07-20T07:26:24.081Z", name: "Award Points"),
    Statement(status: "Remittance to Ahmad", type: "Debit", points: "3000", date: "2020-07-15T07:26:24.081Z", name: "Award Points"),
    Statement(status: "Remittance to Ahmad", type: "Debit", points: "2000", date: "2020-07-18T07:26:24.081Z", name: "Award Points"),
    Statement(status: "Remittance to Ahmad", type: "Credit", points: "10000", date: "2020-07-01T07:26:24.081Z", name: "Award Points"),
    Statement(status: "Remittance to Ahmad", type: "Credit", points: "500000", date: "2020-06-11T07:26:24.081Z", name: "Award Points"),
    Statement(status: "Remittance to Ahmad", type: "Debit", points: "3000", date: "2020-07-18T07:26:24.081Z", name: "Award Points"),
    Statement(status: "Remittance to Ahmad", type: "Debit", points: "4000", date: "2020-08-18T07:26:24.081Z", name: "Award Points"),
    Statement(status: "Remittance to Ahmad", type: "Credit", points: "6000", date: "2020-08-18T07:26:24.081Z", name: "Award Points"),
    Statement(status: "Remittance to Ahmad", type: "Debit", points: "7000", date: "2020-08-18T07:26:24.081Z", name: "Award Points"),
    Statement(status: "Remittance to Ahmad", type: "Credit", points: "8000", date: "2020-08-18T07:26:24.081Z", name: "Award Points") ]
    
    var zeroStatement: Bool = false
    
    func fetchLoyaltyStatement(requestModel: FetchLoyaltyStatementRequestModel, responseHandler: @escaping FetchLoyaltyPointsCallBack) {
        
        let responseData = LoyaltyStatementResponseData(currentpointbalance: "1234.45", statements: statements)
        if zeroStatement {
            responseHandler(.success(FetchLoyaltyStatementResponseModel(data: LoyaltyStatementResponseData(currentpointbalance: "1234.12", statements: []), message: "success")))
        } else {
            responseHandler(.success(FetchLoyaltyStatementResponseModel(data: responseData, message: "success")))
        }
        
    }
    
    func fetchLoyaltyAdvanceStatement(requestModel: FetchLoyaltyAdvanceStatementRequestModel, responseHandler: @escaping FetchLoyaltyPointsCallBack) {
        
        responseHandler(.success(FetchLoyaltyStatementResponseModel(data: LoyaltyStatementResponseData(currentpointbalance: "1234.45", statements: statements), message: "Success")))
        
    }
    
    func transferLoyaltyPoints(requestModel: LoyaltyPointsRequestModel, responseHandler: @escaping TransferLoyaltyPointsCallBack) {
    
        responseHandler(.success(LoyaltyPointsResponseModel(message: "Success")))
    }
    
    func fetchLoyaltyAdvanceStatement(requestModel: FetchLoyaltyAdvanceStatementRequestModel, responseHandler: @escaping FetchAdvanceLoyaltyPointsCallBack) {
        responseHandler(.success(AdvanceLoyaltyStatementResponseModel(message: "success")))
    }
}

class LoyaltyPointsServiceNegativeMock: LoyaltyPointsServiceProtocol {
    
    func fetchLoyaltyStatement(requestModel: FetchLoyaltyStatementRequestModel, responseHandler: @escaping FetchLoyaltyPointsCallBack) {
        
        responseHandler(.failure(.internetOffline))
    }
    
    func fetchLoyaltyAdvanceStatement(requestModel: FetchLoyaltyAdvanceStatementRequestModel, responseHandler: @escaping FetchLoyaltyPointsCallBack) {
        
        responseHandler(.failure(.internetOffline))
    }
    
    func transferLoyaltyPoints(requestModel: LoyaltyPointsRequestModel, responseHandler: @escaping TransferLoyaltyPointsCallBack) {
    
        responseHandler(.failure(.internetOffline))
    }
    
    func fetchLoyaltyAdvanceStatement(requestModel: FetchLoyaltyAdvanceStatementRequestModel, responseHandler: @escaping FetchAdvanceLoyaltyPointsCallBack) {
        responseHandler(.failure(.internetOffline))
    }
}

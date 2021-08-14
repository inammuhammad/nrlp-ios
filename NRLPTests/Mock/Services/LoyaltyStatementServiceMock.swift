//
//  LoyaltyStatementServiceMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 26/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class LoyaltyStatementServiceMock: LoyaltyPointsServiceProtocol {
    
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
    
    func fetchLoyaltyStatement(requestModel: FetchLoyaltyStatementRequestModel, responseHandler: @escaping FetchLoyaltyPointsCallBack) {
        responseHandler(.success(FetchLoyaltyStatementResponseModel(data: LoyaltyStatementResponseData(currentpointbalance: "1234.50    ", statements: statements), message: "success")))
    }
    
    func fetchLoyaltyAdvanceStatement(requestModel: FetchLoyaltyAdvanceStatementRequestModel, responseHandler: @escaping FetchLoyaltyPointsCallBack) {
        responseHandler(.success(FetchLoyaltyStatementResponseModel(data: LoyaltyStatementResponseData(currentpointbalance: "1234.50", statements: statements), message: "success")))
    }
    
    func transferLoyaltyPoints(requestModel: LoyaltyPointsRequestModel, responseHandler: @escaping TransferLoyaltyPointsCallBack) {
        responseHandler(.success(LoyaltyPointsResponseModel(message: "success")))
    }
    
    func fetchLoyaltyAdvanceStatement(requestModel: FetchLoyaltyAdvanceStatementRequestModel, responseHandler: @escaping FetchAdvanceLoyaltyPointsCallBack) {
        responseHandler(.success(AdvanceLoyaltyStatementResponseModel(message: "success")))
    }
}

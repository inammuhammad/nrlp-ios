//
//  RedeemServiceMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 31/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class RedeemServicePositiveMock: RedeemService {
    override func redeemPointsInitialize(requestModel: RedeemInitializeRequestModel, responseHandler: @escaping RedeemLoyaltyInititeCallback) {
        responseHandler(.success(RedeemInitializeResponseModel(message: "OTP send to your mobile number", transactionId: "abcdef")))
        
    }
    override func fetchLoyaltyPartners(requestModel: PartnerCategoriesRequestModel, responseHandler: @escaping FetchLoyaltyPartnersCallBack) {
        responseHandler(.success(PartnerCategoriesResponseModel(message: "success", data: [getMockPartner(), getMockPartner()])))
    }
    
    override func verifyOTP(requestModel: RedeemVerifyOTPRequestModel, responseHandler: @escaping RedeemLoyaltyOTPCallback) {
        responseHandler(.success(RedeemVerifyOTPResponseModel(message: "OTP verified successfully")))
        
    }
    
    override func redeemComplete(requestModel: RedeemCompleteRequestModel, responseHandler: @escaping RedeemLoyaltyCompleteCallback) {
        responseHandler(.success(RedeemCompleteResponseModel(message: "Redemption successfully completed", transactionId: "abcdef")))
        
    }
    
    override func resendOTP(requestModel: RedeemResentOTPRequestModel, responseHandler: @escaping RedeemLoyaltyOTPCallback) {
        responseHandler(.success(RedeemVerifyOTPResponseModel(message: "success")))
    }
}

class RedeemServiceNegativeMock: RedeemService {
    override func redeemPointsInitialize(requestModel: RedeemInitializeRequestModel, responseHandler: @escaping RedeemLoyaltyInititeCallback) {
        responseHandler(.failure(.internetOffline))
    }
    override func fetchLoyaltyPartners(requestModel: PartnerCategoriesRequestModel, responseHandler: @escaping FetchLoyaltyPartnersCallBack) {
        responseHandler(.failure(.internetOffline))
    }
    
    override func verifyOTP(requestModel: RedeemVerifyOTPRequestModel, responseHandler: @escaping RedeemLoyaltyOTPCallback) {
        responseHandler(.failure(.internetOffline))
    }
    
    override func redeemComplete(requestModel: RedeemCompleteRequestModel, responseHandler: @escaping RedeemLoyaltyCompleteCallback) {
        responseHandler(.failure(.internetOffline))
        
    }
    
    override func resendOTP(requestModel: RedeemResentOTPRequestModel, responseHandler: @escaping RedeemLoyaltyOTPCallback) {
        responseHandler(.failure(.internetOffline))
    }
}

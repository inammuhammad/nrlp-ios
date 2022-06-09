//
//  RedeemService.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 31/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias FetchLoyaltyPartnersCallBack = (Result<PartnerCategoriesResponseModel, APIResponseError>) -> Void
typealias RedeemLoyaltyInititeCallback = (Result<RedeemInitializeResponseModel, APIResponseError>) -> Void
typealias RedeemLoyaltyOTPCallback = (Result<RedeemVerifyOTPResponseModel, APIResponseError>) -> Void
typealias RedeemLoyaltyCompleteCallback = (Result<RedeemCompleteResponseModel, APIResponseError>) -> Void

protocol RedeemServiceProtocol {
    func redeemPointsInitialize(requestModel: RedeemInitializeRequestModel, responseHandler: @escaping RedeemLoyaltyInititeCallback)
    func fetchLoyaltyPartners(requestModel: PartnerCategoriesRequestModel, responseHandler: @escaping FetchLoyaltyPartnersCallBack)
    func verifyOTP(requestModel: RedeemVerifyOTPRequestModel, responseHandler: @escaping RedeemLoyaltyOTPCallback)
    func redeemComplete(requestModel: RedeemCompleteRequestModel, responseHandler: @escaping RedeemLoyaltyCompleteCallback)
    func resendOTP(requestModel: RedeemResentOTPRequestModel, responseHandler: @escaping RedeemLoyaltyOTPCallback)
}

extension RedeemServiceProtocol {
    func fetchLoyaltyPartners(responseHandler: @escaping FetchLoyaltyPartnersCallBack) {
        fetchLoyaltyPartners(requestModel: PartnerCategoriesRequestModel(), responseHandler: responseHandler)
    }
}

class RedeemService: BaseDataStore, RedeemServiceProtocol {

    var partners: [Partner] = [
        Partner(id: 1, partnerName: "Pakistan International Airline", categories: [Category(id: 1, categoryName: "New Ticket", pointsAssigned: 8000), Category(id: 2, categoryName: "Renew Ticket", pointsAssigned: 200)]),
        Partner(id: 2, partnerName: "NADRA", categories: [Category(id: 1, categoryName: "New CNIC", pointsAssigned: 8000), Category(id: 2, categoryName: "Renew CNIC", pointsAssigned: 4000)]),
        Partner(id: 3, partnerName: "Pakistan Post office", categories: [Category(id: 1, categoryName: "Send Parcel", pointsAssigned: 8000), Category(id: 2, categoryName: "Send Documents", pointsAssigned: 4000)]),
        Partner(id: 4, partnerName: "Civil Aviation Authority", categories: [Category(id: 1, categoryName: "Large Cargo", pointsAssigned: 8000), Category(id: 2, categoryName: "Small Cargo", pointsAssigned: 3000)]),
        Partner(id: 5, partnerName: "National Database & Registration Authority", categories: [Category(id: 1, categoryName: "Item No.1", pointsAssigned: 8000), Category(id: 2, categoryName: "Item No.2", pointsAssigned: 3000)])
        
    ]

    func redeemPointsInitialize(requestModel: RedeemInitializeRequestModel, responseHandler: @escaping RedeemLoyaltyInititeCallback) {
  //      responseHandler(.success(RedeemInitializeResponseModel(message: "OTP send to your mobile number", transactionId: "abc")))
        
        let request = RequestBuilder(path: APIPathBuilder(endPoint: .redeemInitialize), parameters: requestModel)
        networking.post(request: request) { (response: APIResponse<RedeemInitializeResponseModel>) in
            responseHandler(response.result)
        }
    }
    func fetchLoyaltyPartners(requestModel: PartnerCategoriesRequestModel, responseHandler: @escaping FetchLoyaltyPartnersCallBack) {
//        responseHandler(.success(PartnerCategoriesResponseModel(message: "success", data: partners)))
        let request = RequestBuilder(path: APIPathBuilder(endPoint: .redeemPartnerCategory), parameters: requestModel, shouldHash: false)
        
        networking.get(request: request) { (response: APIResponse<PartnerCategoriesResponseModel>) in
            responseHandler(response.result)
        }
    }

    func verifyOTP(requestModel: RedeemVerifyOTPRequestModel, responseHandler: @escaping RedeemLoyaltyOTPCallback) {
//        responseHandler(.success(RedeemVerifyOTPResponseModel(message: "OTP verified successfully")))
        
        let request = RequestBuilder(path: APIPathBuilder(endPoint: .redeemVerifyOTP), parameters: requestModel)
        networking.post(request: request) { (response: APIResponse<RedeemVerifyOTPResponseModel>) in
            responseHandler(response.result)
        }
    }
    
    func resendOTP(requestModel: RedeemResentOTPRequestModel, responseHandler: @escaping RedeemLoyaltyOTPCallback) {
    //        responseHandler(.success(RedeemVerifyOTPResponseModel(message: "OTP verified successfully")))
            
            let request = RequestBuilder(path: APIPathBuilder(endPoint: .resentRedeemOTP), parameters: requestModel)
            networking.post(request: request) { (response: APIResponse<RedeemVerifyOTPResponseModel>) in
                responseHandler(response.result)
            }
        }

    func redeemComplete(requestModel: RedeemCompleteRequestModel, responseHandler: @escaping RedeemLoyaltyCompleteCallback) {
//        responseHandler(.success(RedeemCompleteResponseModel(message: "Redemption successfully completed", transactionId: "abcdef")))
        
        let request = RequestBuilder(path: APIPathBuilder(endPoint: .redeemComplete), parameters: requestModel)
        networking.post(request: request) { (response: APIResponse<RedeemCompleteResponseModel>) in
            responseHandler(response.result)
        }
    }
    
    func submitRedemptionRating(requestModel: RedemptionRatingModel, responseHandler: @escaping RedemptionRatingCallback) {

        let request = RequestBuilder(path: APIPathBuilder(endPoint: .customerSatisfactionRating), parameters: requestModel)
        networking.post(request: request) { (response: APIResponse<RedemptionRatingResponseModel>) in
            responseHandler(response.result)
        }
    }
}

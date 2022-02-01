//
//  ComplaintService.swift
//  NRLP
//
//  Created by Bilal Iqbal on 28/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias ComplaintSubmittedCompletionHandler = (Result<ComplaintResponseModel, APIResponseError>) -> Void
typealias ComplaintTransactionTypesCompletionHandler = (Result <ComplaintTransactionTypesResponseModel, APIResponseError>) -> Void

protocol ComplaintServiceProtocol {

    func submitComplaint(requestModel: ComplaintRequestModel?, completion: @escaping ComplaintSubmittedCompletionHandler)
    func getTransactionTypes(completion: @escaping ComplaintTransactionTypesCompletionHandler)
}

class ComplaintService: BaseDataStore, ComplaintServiceProtocol {
    func submitComplaint(requestModel: ComplaintRequestModel?, completion: @escaping ComplaintSubmittedCompletionHandler) {
        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }
        
        let request = RequestBuilder(path: .init(endPoint: .addComplaints), parameters: requestModel, shouldHash: false)
        
        networking.post(request: request) { (response: APIResponse<ComplaintResponseModel>) in
            completion(response.result)
        }
    }
    
    func getTransactionTypes(completion: @escaping ComplaintTransactionTypesCompletionHandler) {
        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }
        
        let request = RequestBuilder(path: .init(endPoint: .complaintsTransactionTypes), parameters: ComplaintTransactionTypesRequestModel(), shouldHash: false)
        
        networking.get(request: request) { (response: APIResponse<ComplaintTransactionTypesResponseModel>) in
            completion(response.result)
        }
    }
}

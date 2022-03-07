//
//  RemitterReceiverService.swift
//  NRLP
//
//  Created by Bilal Iqbal on 03/03/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias FetchListingCompletionHandler = (Result<ReceiverListResponseModel, APIResponseError>) -> Void
typealias AddRecieverCompletionHandler = (Result <AddReceiverResponseModel, APIResponseError>) -> Void
typealias DeleteReceiverCompletionHandler = (Result<DeleteReceiverResponseModel, APIResponseError>) -> Void

protocol RemitterReceiverServiceProtocol {

    func getReceiverListing(completion: @escaping FetchListingCompletionHandler)
    func addReceiver(requestModel: AddReceiverRequestModel, completion: @escaping AddRecieverCompletionHandler)
    func deleteReceiver(requestModel: DeleteReceiverRequestModel, completion: @escaping DeleteReceiverCompletionHandler)
}

class RemitterReceiverService: BaseDataStore, RemitterReceiverServiceProtocol {
    
    func getReceiverListing(completion: @escaping FetchListingCompletionHandler) {
        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }
        
        let request = RequestBuilder(path: .init(endPoint: .remitterReceiverList), parameters: EmptyModel(), shouldHash: false)
        
        networking.get(request: request) { (response: APIResponse<ReceiverListResponseModel>) in
            completion(response.result)
        }
    }
    
    func addReceiver(requestModel: AddReceiverRequestModel, completion: @escaping AddRecieverCompletionHandler) {
        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }
        
        let request = RequestBuilder(path: .init(endPoint: .addReceiver), parameters: requestModel)
        
        networking.post(request: request) { (response: APIResponse<AddReceiverResponseModel>) in
            completion(response.result)
        }
    }
    
    func deleteReceiver(requestModel: DeleteReceiverRequestModel, completion: @escaping DeleteReceiverCompletionHandler) {
        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }
        
        let request = RequestBuilder(path: .init(endPoint: .deleteReceiver), parameters: requestModel)
        
        networking.post(request: request) { (response: APIResponse<DeleteReceiverResponseModel>) in
            completion(response.result)
        }
    }
}

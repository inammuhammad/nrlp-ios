//
//  FatherNameService.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 05/06/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import Foundation

typealias FatherNameServiceCallBack = (Result<FatherNameResponseModel, APIResponseError>) -> Void

protocol FatherNameServiceProtocol {
    func updateFatherName(model: FatherNameRequestModel, completion: @escaping FatherNameServiceCallBack)
}

class FatherNameService: BaseDataStore, FatherNameServiceProtocol {
    
    func updateFatherName(model: FatherNameRequestModel, completion: @escaping FatherNameServiceCallBack) {

        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }

        let request = RequestBuilder(path: .init(endPoint: .fatherVerification), parameters: model, shouldHash: false)
        
        networking.post(request: request) { (response: APIResponse<FatherNameResponseModel>) in
            completion(response.result)
        }
    }
}

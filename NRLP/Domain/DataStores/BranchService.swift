//
//  BranchService.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 06/07/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import Foundation

typealias BranchListServiceCallBack = (Result<BranchListResponseModel, APIResponseError>) -> Void

protocol BranchListServiceProtocol {

    func fetchBranches(pseName: String, completion: @escaping BranchListServiceCallBack)
}

class BranchListService: BaseDataStore, BranchListServiceProtocol {
    func fetchBranches(pseName: String, completion: @escaping BranchListServiceCallBack) {

        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }

        let request = RequestBuilder(path: .init(endPoint: .branchList), parameters: BranchListRequestModel(pseName: pseName), shouldHash: false)
        
        networking.post(request: request) { (response: APIResponse<BranchListResponseModel>) in
            completion(response.result)
        }
    }
}

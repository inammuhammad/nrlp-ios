//
//  RemitterVerificationService.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias VerifyReferenceNumberCallBack = (Result<VerifyReferenceNumberResponseModel, APIResponseError>) -> Void

protocol RemitterVerificationServiceProtocol {

    func verifyCode(requestModel: VerifyReferenceNumberRequestModel, completion: @escaping VerifyReferenceNumberCallBack)
}

class RemitterVerificationService: BaseDataStore, RemitterVerificationServiceProtocol {

    func verifyCode(requestModel: VerifyReferenceNumberRequestModel, completion: @escaping VerifyReferenceNumberCallBack) {

        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }

        //      Success Case
          //      completion(.success(VerifyReferenceNumberResponseModel(message: "Remitter verified successfully")))

        // request building
        let request = RequestBuilder(path: .init(endPoint: .referenceNumber), parameters: requestModel)

        networking.post(request: request) { (response: APIResponse<VerifyReferenceNumberResponseModel>) in

            completion(response.result)
        }

    }

}

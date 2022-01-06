//
//  NadraVerificationService.swift
//  NRLP
//
//  Created by Bilal Iqbal on 04/01/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias NadraVerificationCompletionHandler = (Result<NadraVerificationResponseModel, APIResponseError>) -> Void

protocol NadraVerificationServiceProtocol {

    func verifyUser(requestModel: NadraVerificationRequestModel?, completion: @escaping NadraVerificationCompletionHandler)
    
}

class NadraVerificationService: BaseDataStore, NadraVerificationServiceProtocol {
    func verifyUser(requestModel: NadraVerificationRequestModel?, completion: @escaping NadraVerificationCompletionHandler) {
        
        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }
        
        let request = RequestBuilder(path: .init(endPoint: .verifyNadra), parameters: requestModel)
        
        networking.post(request: request) { (response: APIResponse<NadraVerificationResponseModel>) in
            completion(response.result)
        }
    }

}
 

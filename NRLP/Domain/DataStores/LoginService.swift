//
//  LoginDataStore.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias UUIDUpdateCompletionHandler = (Result<UUIDUpdateOTPResponseModel, APIResponseError>) -> Void
typealias LoginServiceCompletionHandler = (Result<LoginResponseModel, APIResponseError>) -> Void

protocol LoginServiceProtocol {
    func login(requestModel: LoginRequestModel?, responseHandler: @escaping LoginServiceCompletionHandler)
    func updateUUID(requestModel: UUIDUpdateOTPRequestModel?, responseHandler: @escaping UUIDUpdateCompletionHandler)
    func resentUUID(requestModel: LoginRequestModel?, responseHandler: @escaping UUIDUpdateCompletionHandler)
}

class LoginService: BaseDataStore, LoginServiceProtocol {
    
    func login(requestModel: LoginRequestModel?, responseHandler: @escaping LoginServiceCompletionHandler) {
        //  request building
        var shouldHash = true
        
        if requestModel?.cnicNicop == TestConstants.CNIC1.rawValue || requestModel?.cnicNicop == TestConstants.CNIC2.rawValue || requestModel?.cnicNicop == TestConstants.CNIC3.rawValue {
            shouldHash = false
        }
        
        let request = RequestBuilder(path: .init(endPoint: .login), parameters: requestModel, shouldHash: shouldHash)
        networking.remove(headerKeys: ["session_key"])
        
        networking.post(request: request) { (response: APIResponse<LoginResponseModel>) in
            
            switch response.result {
            case .success(var value):
                value.user.type = requestModel?.accountType
                if let token = value.token, let sessionKey = value.sessionKey {
                    self.addNewHeaders(headers: ["Authorization": "Bearer \(token)", "session_key": sessionKey])
                }
                if let inActivityTime = Int(value.inActivityTime ?? "") {
                    // Inactivity time received is in milliseconds.
                    NRLPUserDefaults.shared.setMaxInActivityDuration(duration: inActivityTime/1000)
                }
                
                if let beneficiariesAllowed = value.numberOfBeneficiariesAllowed {
                    NRLPUserDefaults.shared.setMaxBeneficiariesAllowed(number: beneficiariesAllowed)
                }
                self.removeHeader("random_key")
                RequestKeyGenerator.reset()
                responseHandler(.success(value))
            case .failure(let error):
                responseHandler(.failure(error))
            }
        }
    }
    
    func updateUUID(requestModel: UUIDUpdateOTPRequestModel?, responseHandler: @escaping UUIDUpdateCompletionHandler) {
        if !NetworkState.isConnected() {
            responseHandler(.failure(.internetOffline))
            return
        }
        
        let request = RequestBuilder(path: .init(endPoint: .uuid), parameters: requestModel)
        
        networking.post(request: request) { (response: APIResponse<UUIDUpdateOTPResponseModel>) in
            responseHandler(response.result)
        }
        
    }
    
    func resentUUID(requestModel: LoginRequestModel?, responseHandler: @escaping UUIDUpdateCompletionHandler) {
        if !NetworkState.isConnected() {
            responseHandler(.failure(.internetOffline))
            return
        }
        
        let request = RequestBuilder(path: .init(endPoint: .resentUUIDChangeOTP), parameters: requestModel)
        
        networking.post(request: request) { (response: APIResponse<UUIDUpdateOTPResponseModel>) in
            responseHandler(response.result)
        }
        
    }
}

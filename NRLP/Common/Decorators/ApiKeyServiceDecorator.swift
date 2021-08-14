//
//  ApiKeyServiceDecorator.swift
//  NRLP
//
//  Created by Muhammad Usman Tatla on 15/02/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

final class APIKeyServiceDecorator<T> {
    let decoratee: T
    private let appKeyService: AppKeyServiceProtocol
    
    init(decoratee: T, appKeyService: AppKeyServiceProtocol) {
        self.decoratee = decoratee
        self.appKeyService = appKeyService
    }
    
    func dispatchForKey(cnic: String, type: AccountType, completion: @escaping (_ error: APIResponseError?) -> Void) {
        if AESConfigs.hasIV && RequestKeyGenerator.sameCNIC(cnic: cnic) && RequestKeyGenerator.sameAccountType(type: type) {
            completion(nil)
            return
        }
        
         appKeyService.fetchAppKey(cnic: cnic, type: type) {(result) in
            switch result {
            case .success(let response):
                let configuration = AESConfigs.keyConfigurationsFor(.randomKey)
                let decryptedKey = response.data.key.aesDecrypted(key: configuration.key, iv: configuration.iv )
                if decryptedKey.isEmpty {
                    completion(.unknown)
                    return
                }
                AESConfigs.setIV(iv: decryptedKey)
                debugPrint("IVIS: \(decryptedKey)")
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}

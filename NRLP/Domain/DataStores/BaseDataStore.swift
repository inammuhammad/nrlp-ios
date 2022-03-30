//
//  BaseDataStore.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 14/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

class BaseDataStore {

    enum Constants {
        case certificateName
        case evaluator
        
        var rawValue: String {
            switch self {
            case .certificateName:
                return AppConstants.isDev ? "sni-cloudflaressl-com-chain-dev" : "sni-cloudflaressl-com-chain"
            case .evaluator:
                return AppConstants.isDev ? "sandboxapi.1link.net.pk" : "api.nrlp.com.pk"
            }
        }
    }
    
    let networking: Networking

    init() {

        let sessionConfigurations = URLSessionConfiguration.default
        
        sessionConfigurations.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        sessionConfigurations.urlCache = nil
        
        sessionConfigurations.httpAdditionalHeaders = APIRequestHeader().processRequestHeader()
        
        //SSL Pinning Certificate
//        let certificate = CertificateManager.certificate(filename: Constants.certificateName.rawValue)
//
//        let serverTrustManager = ServerTrustPolicyManager(certificates: [certificate!], isToPinnedPublicKey: false, hostEvaluators: [Constants.evaluator.rawValue])
        
        // REMOVED SSL Pinning TO ENABLE LOGIN
        
        // let configurations = Configuration(sessionConfigurations: .default, serverTrustPolicyManager: serverTrustManager)
        let configurations = Configuration()
      
        let networkManager = NetworkManager.getSharedObj(configuration: configurations)
        self.networking = networkManager
    }

    func addNewHeaders(headers: [String: String]) {
        networking.add(headers: headers)
    }
    
    func removeHeader(_ key: String) {
        networking.remove(headerKeys: [key])
    }
}

//
//  AlamofireManager.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 13/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import Alamofire

final public class NetworkManager {

    // MARK: - Properties

    /// A shared instance of `AlamofireManager`.
    public static var shared: NetworkManager!
    private var configuration: Configurable
    /// An instance of `Session`.
    public var sessionManager: Session!

    static func getSharedObj(configuration: Configurable = Configuration.shared) -> NetworkManager {
        if let shared = shared {
            return shared
        } else {
            shared = NetworkManager(configuration: configuration)
            return shared
        }
    }

    private init(configuration: Configurable = Configuration.shared) {
        self.configuration = configuration
        self.sessionManager = Session(configuration: configuration.sessionConfigurations,
                                      serverTrustManager: configureDefaultPinning(configuration.serverTrustPolicyManager))

    }

    public func set(configuration: Configurable = Configuration.shared) {
        self.sessionManager = Session(configuration: configuration.sessionConfigurations,
                                      serverTrustManager: configureDefaultPinning(configuration.serverTrustPolicyManager))
    }

    private func configureDefaultPinning(_ serverTrustPolicyManager: ServerTrustPolicyManager?) -> ServerTrustManager? {

        guard let serverTrustPolicyManager = serverTrustPolicyManager else { return nil }

        let evaluators = serverTrustPolicyManager.hostEvaluators.reduce([String: ServerTrustEvaluating]()) { (dict, host) -> [String: ServerTrustEvaluating] in
            var dict = dict
            dict[host] = ( serverTrustPolicyManager.isToPinnedPublicKey ) ? PublicKeysTrustEvaluator(keys: serverTrustPolicyManager.publicKeys) : PinnedCertificatesTrustEvaluator(certificates: serverTrustPolicyManager.certificates)
            return dict
        }
        let policyManager =  ServerTrustManager(allHostsMustBeEvaluated: true, evaluators: evaluators)
        return policyManager
    }

    public func add(headers: [AnyHashable: String]) {

        let sessionConfiguration = sessionManager.sessionConfiguration

        var oldHeaders = sessionConfiguration.httpAdditionalHeaders ?? [:]
        headers.forEach { oldHeaders[$0.key] = $0.value }
        sessionConfiguration.httpAdditionalHeaders = oldHeaders
        sessionManager = Alamofire.Session(configuration: sessionConfiguration, serverTrustManager: configureDefaultPinning(self.configuration.serverTrustPolicyManager))
    }

    public func remove(headerKeys: [AnyHashable]) {
        let sessionConfiguration = sessionManager.sessionConfiguration

        var oldHeaders = sessionConfiguration.httpAdditionalHeaders ?? [:]
        headerKeys.forEach { oldHeaders.removeValue(forKey: $0) }
        sessionConfiguration.httpAdditionalHeaders = oldHeaders
        sessionManager = Alamofire.Session(configuration: sessionConfiguration, serverTrustManager: configureDefaultPinning(self.configuration.serverTrustPolicyManager))
    }
}

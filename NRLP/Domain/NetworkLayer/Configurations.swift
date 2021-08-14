//
//  Configurations.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 13/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

public protocol Configurable {

    var sessionConfigurations: URLSessionConfiguration { get }
    var serverTrustPolicyManager: ServerTrustPolicyManager? { get set }
}

public struct Configuration: Configurable {

    // MARK: - Properties

    /// A default `Configuration` object.

    public static let shared = Configuration()

    /// An instance of `URLSessionConfiguration` object.

    public var sessionConfigurations: URLSessionConfiguration

    /// A configuration which determines whether to inject Certificate Pinning or not.
    public var serverTrustPolicyManager: ServerTrustPolicyManager?

    // MARK: - Lifecycle

    /// Creates an instance with the specified `configuration`

    /// - Parameters:
    ///     - configuration:            The configuration used to construct the managed session.
    ///                                 `URLSessionConfiguration.default` by default.
    ///     - isToInjectCertificatePinning:

    /// - Returns:                             The new `NetworkManager` instance.

    public init(sessionConfigurations: URLSessionConfiguration = .default,
                serverTrustPolicyManager: ServerTrustPolicyManager? = nil) {

        self.sessionConfigurations = sessionConfigurations
        self.serverTrustPolicyManager = serverTrustPolicyManager
    }

}

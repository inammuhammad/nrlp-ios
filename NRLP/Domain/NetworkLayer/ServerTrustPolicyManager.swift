//
//  ServerTrustPolicyManager.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 13/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import Alamofire

public struct ServerTrustPolicyManager {

    var allHostsMustBeEvaluated: Bool
    var certificates: [SecCertificate]
    var publicKeys: [SecKey]
    var isToPinnedPublicKey: Bool
    var hostEvaluators: [String]

    public init(allHostsMustBeEvaluated: Bool = true, publicKeys: [SecKey] = Bundle.main.af.publicKeys, certificates: [SecCertificate] = Bundle.main.af.certificates, isToPinnedPublicKey: Bool = true, hostEvaluators: [String] = []) {

        self.allHostsMustBeEvaluated = allHostsMustBeEvaluated
        self.certificates = certificates
        self.isToPinnedPublicKey = isToPinnedPublicKey
        self.hostEvaluators = hostEvaluators
        self.publicKeys = publicKeys
    }
}

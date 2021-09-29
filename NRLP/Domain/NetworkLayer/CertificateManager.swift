//
//  CertificateManager.swift
//  1Link-NRLP
//
//  Created by VenD on 14/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct CertificateManager {

    static func certificate(filename: String) -> SecCertificate? {
        if let filePath = Bundle.main.path(forResource: filename, ofType: "der") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
                let certificate = SecCertificateCreateWithData(nil, data as CFData)!
                return certificate
            }
            return nil
        }
        return nil
    }
}

//
//  GenericRequestModifier.swift
//  1Link-NRLP
//
//  Created by VenD on 14/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

protocol RequestHeader {
    var accept: String { get set }
    var contentType: String { get set }
}

//enum HeaderType

final class DefaultRequestHeader: RequestHeader {
    var accept: String = ParameterConstants.contentTypeJson.rawValue
    var contentType: String = ParameterConstants.contentTypeJson.rawValue
    var language: String = "en_US"
    var osVersion = AppConstants.osVersion
    var osName = AppConstants.osName
}

final class APIRequestHeader {
    
    enum HeaderTypes {
        case allEncrypted
        case openApis
        case unencrypted
    }
    
    func processRequestHeader(headers: [String: String] = [:], defaultHeaders: RequestHeader = DefaultRequestHeader()) -> [String: String] {
        
        var defaultHeaderDict: [String: String] = [:]
        var processedHeaders = headers
        
        func getClientId() -> String {
            
            let key: [UInt8]
            
            if AppConstants.isDev {
                key = [108, 93, 16, 90, 21, 114, 89, 81, 110, 88, 87, 86, 91, 89, 93, 13, 91, 50, 72, 19, 78, 88, 2, 72, 119, 102, 118, 6, 11, 81, 90, 76, 102, 83, 71, 9]
            } else {
                key =  [55, 84, 20, 9, 23, 117, 93, 80, 110, 87, 93, 87, 81, 89, 93, 95, 95, 50, 72, 75, 78, 12, 83, 72, 43, 103, 121, 82, 12, 82, 83, 16, 100, 0, 20, 84]
            }
            return Replacer().deformatString(string: key)
        }
        
        func getSecretId() -> String {
            
            let key: [UInt8]
            
            if AppConstants.isDev {
                key = [0, 80, 31, 36, 68, 52, 43, 87, 43, 34, 93, 19, 38, 70, 6, 63, 93, 59, 48, 66, 17, 60, 85, 13, 11, 102, 35, 46, 93, 10, 32, 64, 34, 43, 68, 25, 55, 116, 31, 39, 112, 30, 44, 85, 3, 34, 92, 12, 35, 103]
            } else {
                key = [44, 46, 64, 9, 42, 114, 30, 33, 123, 13, 44, 92, 30, 45, 91, 24, 41, 100, 15, 42, 67, 11, 44, 85, 44, 7, 126, 14, 43, 87, 21, 44, 98, 12, 52, 95, 6, 7, 88, 10, 10, 93, 25, 45, 89, 2, 44, 89, 5, 24]
            }
            
            return Replacer().deformatString(string: key)
        }
        
        if let defaultHeaders = defaultHeaders as? DefaultRequestHeader {
            
            defaultHeaderDict = [
                "Accept": ParameterConstants.contentTypeJson.rawValue,
                ParameterConstants.contentType.rawValue: ParameterConstants.contentTypeJson.rawValue,
//                "language": defaultHeaders.language,
//                "os_version": defaultHeaders.osVersion,
//                "os_name": defaultHeaders.osName,
                "x-ibm-client-id": getClientId(),
                "x-ibm-client-secret": getSecretId()
            ]
        }
        defaultHeaderDict.forEach { processedHeaders[$0.key] = $0.value }
        return defaultHeaderDict
    }
    
    private func getDeviceID(encryptyHeader: Bool) -> String {
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
        return encryptyHeader ? deviceID.aesEncrypted() : deviceID
    }
    
    private func getApplicationVersion(encryptyHeader: Bool) -> String {
        let appVersion = AppConstants.versionNumber
        return encryptyHeader ? appVersion.aesEncrypted() : appVersion
//        return appVersion.aesEncrypted()
    }
    
    func getHeaders(_ encryptionStatus: HeaderTypes, initialValue: [String: String]? = nil) -> [String: String] {
        var headers: [String: String] = [:]
        if let header = initialValue {
            header.forEach {headers[$0.key] = $0.value}
        }
        if encryptionStatus != .openApis {
            if encryptionStatus == .allEncrypted {
                headers["device_id"] = getDeviceID(encryptyHeader: true)
            }
            headers["application_version"] = getApplicationVersion(encryptyHeader: encryptionStatus == .allEncrypted)
        }
        return headers
    }
}

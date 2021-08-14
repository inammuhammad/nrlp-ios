//
//  HTTPTask.swift
//  1Link-NRLP
//
//  Created by VenD on 16/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {

    case request

    case requestParameters(bodyParameters: Encodable?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)

    case requestParametersAndHeaders(bodyParameters: Encodable?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
}

//
//  ParameterEncoding.swift
//  1Link-NRLP
//
//  Created by VenD on 16/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

enum ParameterConstants: String {
    case contentType = "Content-Type"
    case contentTypeJson = "application/json"
}

public enum ParameterEncoding {

    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding

    public func encode(urlRequest: inout URLRequest,
                       bodyParameters: Encodable?,
                       urlParameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)

            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)

            case .urlAndJsonEncoding:
                guard let bodyParameters = bodyParameters,
                    let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)

            }
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}

public struct URLParameterEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {

        guard let url = urlRequest.url else { return }

        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false), !parameters.isEmpty {

            urlComponents.queryItems = [URLQueryItem]()

            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }

        if urlRequest.value(forHTTPHeaderField: ParameterConstants.contentType.rawValue) == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: ParameterConstants.contentType.rawValue)
        }

    }
}

public struct JSONParameterEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: Encodable) throws {
        let jsonAsData = parameters.jsonData
        urlRequest.httpBody = jsonAsData
        if urlRequest.value(forHTTPHeaderField: ParameterConstants.contentType.rawValue) == nil {
            urlRequest.setValue(ParameterConstants.contentTypeJson.rawValue, forHTTPHeaderField: ParameterConstants.contentType.rawValue)
        }
    }
}

//
//  Networking.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 14/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

//2. Request Builder
struct RequestBuilder<Parameter: Encodable> {
    
    let path: APIPathBuilder
    let parameters: Parameter
    let headers: [String: String]?
    let hashedParamaters: HashRequestWrapper<Parameter>?
    
     init(path: APIPathBuilder, parameters: Parameter, headers: [String: String]? = nil, shouldHash: Bool = true) {
        self.path = path
        if let notNullHeaders = headers {
            self.headers =  APIRequestHeader().getHeaders(path.encryptionStatus, initialValue: notNullHeaders)
            
        } else {
            self.headers = APIRequestHeader().getHeaders(path.encryptionStatus, initialValue: APIRequestHeader().processRequestHeader())
        }
        self.parameters = parameters
        self.hashedParamaters = shouldHash ? HashRequestWrapper(payload: parameters) : nil
    }
    
    func urlParamaters() -> [String: Any]? {
        var params: [String: Any]?
        if hashedParamaters == nil {
            params = try? JSONTranslation().toMap(withModel: parameters)
        } else {
            params = try? JSONTranslation().toMap(withModel: hashedParamaters)
        }
        return params
    }
}

//3. API Response
struct APIResponse<T> {
    
    let result: Result<T, APIResponseError>
}

struct ErrorResponse: Decodable {
    var message: String
    var errorCode: String
    
    init(message: String, errorCode: String) {
        self.message = message
        self.errorCode = errorCode
    }
}

public enum Result<T, U> {
    
    case success(T)
    case failure(U)
}

//4. Cancelable Request
protocol APIRequest {
    
    func cancel()
}

//5. Perferm API request using differnt restful methods
protocol Networking {
    
    typealias Completion<T> = (APIResponse<T>) -> Void
    
    func add(headers: [AnyHashable: String])
    func remove(headerKeys: [AnyHashable])
    
    @discardableResult
    func get<T: Decodable, R: Encodable>(request: RequestBuilder<R>, completion: @escaping Completion<T>) -> APIRequest?
    @discardableResult
    func post<T: Decodable, R: Encodable>(request: RequestBuilder<R>, completion: @escaping Completion<T>) -> APIRequest?
    @discardableResult
    func put<T: Decodable, R: Encodable>(request: RequestBuilder<R>, completion: @escaping Completion<T>) -> APIRequest?
    @discardableResult
    func patch<T: Decodable, R: Encodable>(request: RequestBuilder<R>, completion: @escaping Completion<T>) -> APIRequest?
    @discardableResult
    func delete<T: Decodable, R: Encodable>(request: RequestBuilder<R>, completion: @escaping Completion<T>) -> APIRequest?
    @discardableResult
    func download<R>(request: RequestBuilder<R>, completion: @escaping (APIResponse<Data>) -> Void) -> APIRequest?
}

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
    let headers: [String: String]? = nil
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
    func delete<T: Decodable, R: Encodable>(request: RequestBuilder<R>, completion: @escaping Completion<T>) -> APIRequest?
    @discardableResult
    func download<R>(request: RequestBuilder<R>, completion: @escaping (APIResponse<Data>) -> Void) -> APIRequest?
}

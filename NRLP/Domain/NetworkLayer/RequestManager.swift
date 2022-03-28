//
//  NetworkManager1.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 14/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import Alamofire

struct DefaultAPIRequest: APIRequest {
    
    let request: DataRequest
    func cancel() {
        request.cancel()
    }
}

extension NetworkManager: Networking {
    func get<T, R>(request: RequestBuilder<R>, completion: @escaping (APIResponse<T>) -> Void) -> APIRequest? where T: Decodable, R: Encodable {
        
        let task = HTTPTask.requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .urlAndJsonEncoding, urlParameters: request.urlParamaters(), additionHeaders: request.headers)
        return dispatch(with: request.path.url, method: .get, task: task, completion: completion)
    }
    
    func post<T, R>(request: RequestBuilder<R>, completion: @escaping (APIResponse<T>) -> Void) -> APIRequest? where T: Decodable, R: Encodable {
        
        let task = HTTPTask.requestParametersAndHeaders(bodyParameters: request.hashedParamaters ?? request.parameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: request.headers)
        return dispatch(with: request.path.url, method: .post, task: task, completion: completion)
    }
    
    func put<T, R>(request: RequestBuilder<R>, completion: @escaping (APIResponse<T>) -> Void) -> APIRequest? where T: Decodable, R: Encodable {
        
        let task = HTTPTask.requestParametersAndHeaders(bodyParameters: request.hashedParamaters ?? request.parameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: request.headers)
        return dispatch(with: request.path.url, method: .put, task: task, completion: completion)
    }
    
    func delete<T, R>(request: RequestBuilder<R>, completion: @escaping (APIResponse<T>) -> Void) -> APIRequest? where T: Decodable, R: Encodable {
        
        let task = HTTPTask.requestParametersAndHeaders(bodyParameters: request.hashedParamaters ?? request.parameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: request.headers)
        return dispatch(with: request.path.url, method: .delete, task: task, completion: completion)
    }
    
    func download<R>(request: RequestBuilder<R>, completion: @escaping (APIResponse<Data>) -> Void) -> APIRequest? where R: Encodable {
        
        let task = HTTPTask.requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .urlAndJsonEncoding, urlParameters: request.urlParamaters(), additionHeaders: request.headers)
        return dispatchDownloadData(with: request.path.url, method: .get, task: task, completion: completion)
    }
    
    func patch<T, R>(request: RequestBuilder<R>, completion: @escaping (APIResponse<T>) -> Void) -> APIRequest? where T: Decodable, R: Encodable {
        
        let task = HTTPTask.requestParametersAndHeaders(bodyParameters: request.hashedParamaters ?? request.parameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: request.headers)
        return dispatch(with: request.path.url, method: .patch, task: task, completion: completion)
    }
    
    func dispatchDownloadData(with request: String,
                              method: HTTPMethod,
                              task: HTTPTask,
                              completion: @escaping Completion<Data>) -> APIRequest? {
        
        if !NetworkState.isConnected() {
            completion(APIResponse(result: .failure(.internetOffline)))
            return nil
        }
        
        do {
            let urlRequest = try buildRequest(with: request, method: method, task: task)
            
            let dataRequest = sessionManager.request(urlRequest)
                .responseData(completionHandler: { (response) in
                    if let data = response.data {
                        completion(APIResponse(result: .success(data)))
                    } else {
                        completion(APIResponse(result: .failure(.fileDownloadingFailed(response.error))))
                    }
                })
            return DefaultAPIRequest(request: dataRequest)
        } catch {
            completion(APIResponse(result: .failure(.unknown)))
            return nil //For time but will be replace by actual working
        }
        
    }
    
    func dispatch<T: Decodable>(
        with request: String,
        method: HTTPMethod,
        task: HTTPTask,
        completion: @escaping Completion<T>) -> APIRequest? {
        
        if !NetworkState.isConnected() {
            completion(APIResponse(result: .failure(.internetOffline)))
            return nil
        }
        
        do {
            let urlRequest = try buildRequest(with: request, method: method, task: task)
            
            if AppConstants.isDev {
                print("\n🔷🔷🔷🔷🔷 REQUEST STARTED 🔷🔷🔷🔷🔷\n")
                
                if let method = urlRequest.httpMethod {
                    print("===== URL TO HIT =====")
                    print("\n\(method):   " + String(urlRequest.url?.absoluteString ?? ""))
                }
                if let headers = urlRequest.allHTTPHeaderFields {
                    print("\n=====HEADERS=====")
                    print("\n\(AppUtility.getPrettyJson(dictionary: headers))\n")
                }
                if let params = urlRequest.httpBody {
                    print("=====PARAMETERS=====")
                    print("\n \(AppUtility.getPrettyJson(data: params))")
                }
            }
            let dataRequest = sessionManager.request(urlRequest)
                .responseJSON(completionHandler: { (response) in
                    if AppConstants.isDev {
                        if let error = response.error {
                            print("\n❌❌❌❌❌ ERROR ❌❌❌❌❌\n")
                            print(error)
                            print("\n🔷🔷🔷🔷🔷 REQUEST END 🔷🔷🔷🔷🔷\n")
                        } else {
                            print("\n✅✅✅✅✅ SUCCESS ✅✅✅✅✅\n")
                            if let data = response.data {
                                print(AppUtility.getPrettyJson(data: data))
                                print("\n🔷🔷🔷🔷🔷 REQUEST END 🔷🔷🔷🔷🔷\n")
                            } else {
                                print("DATA NOT AVAILABLE")
                                print("\n🔷🔷🔷🔷🔷 REQUEST END 🔷🔷🔷🔷🔷\n")
                            }
                        }
                    }
                    completion(self.parseResponse(response: response))
                })
            return DefaultAPIRequest(request: dataRequest)
        } catch {
            completion(APIResponse(result: .failure(.unknown)))
            return nil //For time but will be replace by actual working
        }
    }
    
    private func parseResponse<T: Decodable>(response: AFDataResponse<Any>) -> APIResponse<T> {
        let translator = JSONTranslation()
        switch response.response?.statusCode {
        case 200:
            do {
                guard let data = response.data else {
                    //Handle HTTP related errors
                    return APIResponse(result: .failure(.requestError(response.error)))
                }
                //Response object parse
                let responseObject: T = try translator.toObject(withData: data)
                return APIResponse(result: .success(responseObject))
            } catch {
                return parseFailture(response: response)
            }
        default:
            return parseFailture(response: response)
        }
    }
    
    private func parseFailture<T: Decodable>(response: AFDataResponse<Any>) -> APIResponse<T> {
        let translator = JSONTranslation()
        
        if let nsError = response.error?.underlyingError as NSError?,
            nsError.code == -1009 {
            return APIResponse(result: .failure(.internetOffline))
        }
        guard let data = response.data else {
            //Handle HTTP related errors
            return APIResponse(result: .failure(.unknown))
        }
        
        do {
            //Server Error parse
            let serverError: ErrorResponse = try translator.toObject(withData: data)
            if serverError.errorCode == ErrorConstants.sessionExpire.rawValue {
                remove(headerKeys: ["Authorization"])
                return APIResponse(result: .failure(.sessionExpire))
            }
            return APIResponse(result: .failure(.server(serverError)))
        } catch {
            //Handle HTTP related errors
            return APIResponse(result: .failure(.unknown))
        }
    }
}

extension NetworkManager {
    fileprivate func buildRequest(with request: String,
                                  method: HTTPMethod,
                                  task: HTTPTask) throws -> URLRequest {
        
        var request = URLRequest(url: URL(string: request)!,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 60.0)
        
        request.httpMethod = method.rawValue
        do {
            switch task {
            case .request:
                request.setValue(ParameterConstants.contentTypeJson.rawValue, forHTTPHeaderField: ParameterConstants.contentType.rawValue)
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Encodable?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}

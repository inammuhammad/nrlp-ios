//
//  ImageDownloaderService.swift
//  1Link-NRLP
//
//  Created by VenD on 14/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias ImageDownloaderServiceCallBack = (Result<Data, APIResponseError>) -> Void

protocol ImageDownloaderServiceProtocol {
    
    func downloadImage(completion: @escaping ImageDownloaderServiceCallBack)
}

class ImageDownloaderService: BaseDataStore, ImageDownloaderServiceProtocol {
    func downloadImage(completion: @escaping ImageDownloaderServiceCallBack) {
        
        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }
        
        // request building
        let request = RequestBuilder(path: .init(endPoint: .fileDownload), parameters: FileRequestModel())
        networking.download(request: request, method: .get) { (response: APIResponse<Data>) in
            
            completion(response.result)
        }
    }
}

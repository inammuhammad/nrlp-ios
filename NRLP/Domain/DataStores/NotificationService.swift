//
//  NotificationListService.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 16/05/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import Foundation

typealias NotificationListServiceCallBack = (Result<NotificationListResponseModel, APIResponseError>) -> Void
typealias NotificationReadServiceCallBack = (Result<NotificationReadResponseModel, APIResponseError>) -> Void
typealias NotificationDeleteServiceCallBack = (Result<NotificationDeleteResponseModel, APIResponseError>) -> Void

protocol NotificationServiceProtocol {

    func fetchNotifications(category: NotificationCategory, page: Int, completion: @escaping NotificationListServiceCallBack)
    func markRead(notificationId id: Int, completion: @escaping NotificationReadServiceCallBack)
    func delete(notificationId id: Int, completion: @escaping NotificationDeleteServiceCallBack)
}

class NotificationService: BaseDataStore, NotificationServiceProtocol {
    private let cnicNicop: String
    
    init(cnicNicop: String) {
        self.cnicNicop = cnicNicop
        super.init()
    }
    
    func fetchNotifications(category: NotificationCategory, page: Int, completion: @escaping NotificationListServiceCallBack) {

        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }
        
        let model = NotificationListRequestModel(page: "\(page)", perPage: "10", nicNicop: cnicNicop, notificationType: mappedCategory(for: category))

        let request = RequestBuilder(path: .init(endPoint: .notificationList), parameters: model, shouldHash: true)
        
        networking.post(request: request) { (response: APIResponse<NotificationListResponseModel>) in
            completion(response.result)
        }
    }
    
    func markRead(notificationId id: Int, completion: @escaping NotificationReadServiceCallBack) {
        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }
        
        let model = NotificationReadRequestModel(id: "\(id)", isRead: 1)

        let request = RequestBuilder(path: .init(endPoint: .notificationRead), parameters: model, shouldHash: false)
        
        networking.post(request: request) { (response: APIResponse<NotificationReadResponseModel>) in
            completion(response.result)
        }
    }
    
    func delete(notificationId id: Int, completion: @escaping NotificationDeleteServiceCallBack) {
        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }
        
        let model = NotificationReadRequestModel(id: "\(id)", isRead: 1)

        let request = RequestBuilder(path: .init(endPoint: .notificationDelete), parameters: model, shouldHash: false)
        
        networking.post(request: request) { (response: APIResponse<NotificationDeleteResponseModel>) in
            completion(response.result)
        }
    }
    
    private func mappedCategory(for category: NotificationCategory) -> String {
        switch category {
        case .complaints:
            return "COMPLAINT"
//        case .activity:
//            return ""
        }
    }
}

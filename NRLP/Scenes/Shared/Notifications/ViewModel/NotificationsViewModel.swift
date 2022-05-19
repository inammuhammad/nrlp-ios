//
//  NotificationsViewModel.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 30/04/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import Foundation

typealias NotificationsViewModelOutput = (NotificationsViewModel.Output) -> Void

protocol NotificationsViewModelProtocol {
    var output: NotificationsViewModelOutput? { get set }
    var numberOfRows: Int { get }
    
    func populate(cell: NotificationsCategoryCell?, indexPath: IndexPath)

    // func viewModelWillAppear()
    // func getReceiver(at index: Int) -> ReceiverModel
    // func didTapNotification(indexPath: IndexPath)
   //  func notificationMenuClicked()
   //  func deleteNotificationClicked()
}

class NotificationsViewModel: NotificationsViewModelProtocol {
    private let router: NotificationsRouter
    private let notificationListService: NotificationService
    private let categories = NotificationCategory.allCases
    
    var output: NotificationsViewModelOutput?
    
    var notifications = [NotificationRecordModel]()
    
    init(
        router: NotificationsRouter,
        cnicNicop: String
    ) {
        self.router = router
        self.notificationListService = NotificationService(cnicNicop: cnicNicop)
    }
    
    func populate(cell: NotificationsCategoryCell?, indexPath: IndexPath) {
        cell?.populate(with: self.notificationListService, category: categories[indexPath.item])
    }
    
    enum Output {
        
    }
}

extension NotificationsViewModel {
    var numberOfRows: Int {
        notifications.count
    }
}

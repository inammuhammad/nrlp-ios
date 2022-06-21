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

    func populate(view: NotificationsCategoryView, index: Int)
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
    
    func populate(view: NotificationsCategoryView, index: Int) {
        view.populate(with: self.notificationListService, category: categories[index], showError: { error in
            self.output?(.showError(error: error))
        }, activityIndicator: { show in
            self.output?(.showActivityIndicator(show: show))
        })
    }
    
    enum Output {
        case showError(error: APIResponseError)
        case showActivityIndicator(show: Bool)
    }
}

extension NotificationsViewModel {
    var numberOfRows: Int {
        notifications.count
    }
}

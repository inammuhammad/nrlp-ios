//
//  NotificationsCategoryCell.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 30/04/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

enum NotificationCategory: String, CaseIterable {
    case complaints = "Complaints"
    // case activity = "Activity"
}

class NotificationsCategoryCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            setupTableView()
        }
    }
    
    @IBOutlet weak var loadMoreBtn: PrimaryCTAButton! {
        didSet {
            loadMoreBtn.setTitle("Load More".localized, for: .normal)
            loadMoreBtn.setTitle("Load More".localized, for: .selected)
            loadMoreBtn.setTitle("Load More".localized, for: .disabled)
            loadMoreBtn.setTitle("Load More".localized, for: .highlighted)
            loadMoreBtn.addTarget(self, action: #selector(loadMoreBtnAction), for: .touchUpInside)
        }
    }
    
    private var notificationService: NotificationService?
    private var catagory: NotificationCategory?
    private var latestResponse: NotificationListResponseModel? {
        didSet {
            if let response = latestResponse?.data {
                self.notifications.append(contentsOf: response.records)
                
                if let totalPages = response.totalPages,
                   let page = Int(response.page),
                   page == totalPages {
                    loadMoreBtn.isEnabled = false
                }
            }
        }
    }
    
    private var notifications = [NotificationRecordModel]() {
        didSet {
            sortedNotifications = notifications
        }
    }
    
    private var sortedNotifications = [NotificationRecordModel]() {
        didSet {
            let unRead = sortedNotifications.filter { $0.isReadFlag == 0 }.sorted { r0, r1 in notificationSort(r0: r0, r1: r1) }
            let isRead = sortedNotifications.filter { $0.isReadFlag == 1 }.sorted { r0, r1 in notificationSort(r0: r0, r1: r1) }
            
            sortedNotifications = unRead + isRead
            
            tableView.reloadData()
        }
    }

    func populate(with notificationService: NotificationService, category: NotificationCategory) {
        self.notificationService  = notificationService
        fetchNotification(page: 1)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        registerNib()
    }
    
    private func fetchNotification(page: Int) {
        ProgressHUD.show()
        self.notificationService?.fetchNotifications(category: .complaints, page: page, completion: { result in
            ProgressHUD.dismiss()
            switch result {
                
            case .success(let response):
                self.latestResponse = response
            case .failure(let error):
                print(error)
                // or ignore
                // self?.output?(.showError(error: error))
            }
        })
    }
    
    private func registerNib() {
        tableView.register(nibWithCellClass: NotificationTableViewCell.self)
    }
    
    private  func notificationSort(r0: NotificationRecordModel, r1: NotificationRecordModel) -> Bool {
        if let date0 = DateFormat().formatDate(dateString: r0.notificationDatetime, formatter: .dateTimeMilis),
           let date1 = DateFormat().formatDate(dateString: r1.notificationDatetime, formatter: .dateTimeMilis) {
            return date0 > date1
        } else {
            return false
        }
    }
    
    @objc
    private func loadMoreBtnAction(_ sender: PrimaryCTAButton) {
        if let latestResponse = latestResponse?.data,
           let totalPages = latestResponse.totalPages,
           let page = Int(latestResponse.page),
           totalPages > page {
            fetchNotification(page: page + 1)
        } else {
            fetchNotification(page: 1)
        }
    }
}

extension NotificationsCategoryCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withClass: NotificationTableViewCell.self, for: indexPath)
        let index = indexPath.item
        cell.populate(
            notificationRecord: self.sortedNotifications[index]
        ) {
            ProgressHUD.show()
            self.notificationService?.markRead(notificationId: self.sortedNotifications[index].id, completion: { result in
                ProgressHUD.dismiss()
                switch result {
                case .success(let model):
                    if AppConstants.isDev {
                        print(model)
                    }
                    self.sortedNotifications[index].isReadFlag = 1
                case .failure(let error):
                    print(error)
                }
            })
        } onMenuTap: {
            ProgressHUD.show()
            self.notificationService?.delete(notificationId: self.sortedNotifications[index].id, completion: { result in
                ProgressHUD.dismiss()
                switch result {
                case .success(let model):
                    if AppConstants.isDev {
                        print(model)
                    }
                    self.sortedNotifications.remove(at: index)
                case .failure(let error):
                    print(error)
                }
            })
        }

        cell.selectionStyle = .none
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        80
    //    }
}

extension NotificationsCategoryCell {
    // dummy data
    
    static var data = [
        ("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget consequat tortor. Phasellus non risus consectetur, suscipit ipsum et, iaculis neque. Fusce erat quam, sagittis a ullamcorper eu, gravida eu leo. Mauris sodales, dolor eget tincidunt commodo, nulla massa sollicitudin orci, quis semper sem quam a erat. Nunc pretium massa sit amet massa pharetra, ac aliquet ligula luctus. Duis dignissim congue orci, in venenatis elit blandit vitae. Maecenas tempor erat vel nulla vestibulum, sed venenatis dui laoreet. Aenean vitae interdum elit. Etiam sed quam at orci pretium rhoncus et ut leo. Fusce dolor erat, feugiat a turpis vitae, tempus ullamcorper eros.", Date(), false),
        ("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce dolor erat, feugiat a turpis vitae, tempus ullamcorper eros.", Date(), true),
        ("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget consequat tortor. Phasellus non risus consectetur, suscipit ipsum et, iaculis neque. Fusce erat quam, sagittis a ullamcorper eu, gravida eu leo. Mauris sodales, dolor eget tincidunt commodo, nulla massa sollicitudin orci.", Date(), false)
    ]
}

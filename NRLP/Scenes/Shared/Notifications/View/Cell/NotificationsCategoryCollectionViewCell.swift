//
//  NotificationsCategoryCollectionViewCell.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 30/04/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

class NotificationsCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            setupTableView()
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        registerNib()
    }
    
    private func registerNib() {
        tableView.register(nibWithCellClass: NotificationTableViewCell.self)
    }
}

extension NotificationsCategoryCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withClass: NotificationTableViewCell.self, for: indexPath)
        // cell.populate(with: viewModel.getCity(at: indexPath.row).city)
        cell.backgroundColor = indexPath.item == 0 ? .orange : indexPath.item == 1 ? .systemTeal : .purple
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        80
//    }
}

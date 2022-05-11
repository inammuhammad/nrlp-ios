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
    
    private func headerView(for title: String) -> UIView {
        let label = UILabel()
        label.text = title
        label.textColor = UIColor(commonColor: .appGreen)
        label.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.bold, size: .largeFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let view = UIView()
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            // view.topAnchor.constraint(equalTo: label.topAnchor),
            view.leftAnchor.constraint(equalTo: label.leftAnchor),
            view.bottomAnchor.constraint(equalTo: label.bottomAnchor),
            view.rightAnchor.constraint(equalTo: label.rightAnchor)
        ])
        
        return view
    }
}

extension NotificationsCategoryCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView(for: section == 0 ? "New" : "Earlier")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withClass: NotificationTableViewCell.self, for: indexPath)
        let index = indexPath.item
        cell.populate(text: Self.data[index].0, datetime: Self.data[index].1, isRead: Self.data[index].2) {
            Self.data[index].2 = true
            tableView.reloadData()
        } onMenuTap: {
            print("Menu Tapped")
        }

        cell.selectionStyle = .none
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        80
    //    }
}

extension NotificationsCategoryCollectionViewCell {
    // dummy data
    
    static var data = [
        ("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget consequat tortor. Phasellus non risus consectetur, suscipit ipsum et, iaculis neque. Fusce erat quam, sagittis a ullamcorper eu, gravida eu leo. Mauris sodales, dolor eget tincidunt commodo, nulla massa sollicitudin orci, quis semper sem quam a erat. Nunc pretium massa sit amet massa pharetra, ac aliquet ligula luctus. Duis dignissim congue orci, in venenatis elit blandit vitae. Maecenas tempor erat vel nulla vestibulum, sed venenatis dui laoreet. Aenean vitae interdum elit. Etiam sed quam at orci pretium rhoncus et ut leo. Fusce dolor erat, feugiat a turpis vitae, tempus ullamcorper eros.", Date(), false),
        ("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce dolor erat, feugiat a turpis vitae, tempus ullamcorper eros.", Date(), true),
        ("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eget consequat tortor. Phasellus non risus consectetur, suscipit ipsum et, iaculis neque. Fusce erat quam, sagittis a ullamcorper eu, gravida eu leo. Mauris sodales, dolor eget tincidunt commodo, nulla massa sollicitudin orci.", Date(), false)
    ]
}

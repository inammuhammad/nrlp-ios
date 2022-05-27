//
//  NotificationTableViewCell.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 30/04/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet private weak var notificationTextView: UIView! {
        didSet {
            notificationTextView.backgroundColor = UIColor(commonColor: .appGreen)
            notificationTextView.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(messageTapped))
            )
        }
    }
    
    @IBOutlet private weak var notificationTextLabel: UILabel! {
        didSet {
            notificationTextLabel.textColor = .white
            notificationTextLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
            
        }
    }
    
    @IBOutlet private weak var dateTimeLabel: UILabel! {
        didSet {
            dateTimeLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.bold, size: .mediumFontSize)
            dateTimeLabel.textColor = UIColor.init(commonColor: .appLightGray)
            
        }
    }
    
    @IBOutlet private weak var menuButton: UIButton! {
        didSet {
            
        }
    }
    
    @IBOutlet private weak var deleteView: UIView! {
        didSet {
            deleteView.shadowColor = .black
            deleteView.shadowOffset = .zero
            deleteView.shadowRadius = 2
            deleteView.shadowOpacity = 0.5
            
            deleteView.isHidden = true
            deleteView.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(deleteItem))
            )
        }
    }

    @IBOutlet private weak var deleteViewText: UILabel! {
        didSet {
            deleteViewText.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .smallFontSize)
        }
    }
    
    private var onMessageTap: (() -> Void)?
    private var onMenuTap: (() -> Void)?
    private var onDeleteTap: (() -> Void)?
    private var isRead = false
    
    public func populate(
        notificationRecord: NotificationRecordModel,
        menuExtended: Bool,
        onMessageTap: (() -> Void)?,
        onMenuTap: (() -> Void)?,
        onDeleteTap: (() -> Void)?
    ) {
        self.isRead = notificationRecord.isReadFlag == 1
        self.onDeleteTap = onDeleteTap
        self.onMenuTap = onMenuTap
        self.onMessageTap = onMessageTap
        
        deleteView.isHidden = !menuExtended
        
        notificationTextView.backgroundColor = UIColor(commonColor: isRead ? .appLightGray : .appGreen)
        notificationTextLabel.text = notificationRecord.notificationMessage
        if let date = DateFormat().formatDate(dateString: notificationRecord.notificationDatetime, formatter: .dateTimeMilis) {
            dateTimeLabel.text = date.notificationsFormatted
        } else {
            dateTimeLabel.text = ""
        }
    }
    
    @objc private func messageTapped() {
        if !isRead {
            onMessageTap?()
        }
    }
    
    @objc private func deleteItem() {
        onDeleteTap?()
    }
    
    @IBAction private func menuTapped() {
        // deleteView.isHidden.toggle()
        onMenuTap?()
    }
}

private extension Date {
    var notificationsFormatted: String {
        "\(day()) \(monthSuffix()) at \(time())"
    }
    
    func monthSuffix() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let monthSuff = dateFormatter.string(from: self)
        return monthSuff.stringPrefix(3)
    }
    
    func time() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let time = dateFormatter.string(from: self)
        return time.lowercased()
    }
}

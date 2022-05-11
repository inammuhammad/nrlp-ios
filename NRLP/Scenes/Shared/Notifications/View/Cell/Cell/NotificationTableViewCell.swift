//
//  NotificationTableViewCell.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 30/04/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    private var onMessageTap: (() -> Void)?
    private var onMenuTap: (() -> Void)?
    private var isRead = false
    
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
    
    public func populate(
        text: String,
        datetime: Date,
        isRead: Bool,
        onMessageTap: (() -> Void)?,
        onMenuTap: (() -> Void)?
    ) {
        notificationTextView.backgroundColor = UIColor(commonColor: isRead ? .appLightGray : .appGreen)
        notificationTextLabel.text = text
        dateTimeLabel.text = datetime.notificationsFormatted
        
        self.isRead = isRead
        self.onMenuTap = onMenuTap
        self.onMessageTap = onMessageTap
    }
    
    @objc private func messageTapped() {
        if !isRead {
            onMessageTap?()
        }
    }
    
    @IBAction private func menuTapped() {
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

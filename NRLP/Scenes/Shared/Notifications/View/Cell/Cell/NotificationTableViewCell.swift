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
        }
    }
    
    @IBOutlet private weak var notificationTextLabel: UILabel! {
        didSet {
            notificationTextLabel.textColor = .white
            notificationTextLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.bold, size: .mediumFontSize)

        }
    }
    
    @IBOutlet private weak var dateTimeLabel: UILabel! {
        didSet {
            dateTimeLabel.font = UIFont(commonFont: CommonFont.HpSimplifiedFontStyle.bold, size: .mediumFontSize)
            dateTimeLabel.textColor = UIColor.init(commonColor: .appLightGray)

        }
    }
    
    public func populate(text: String, datetime: Date, isRead: Bool) {
        notificationTextView.backgroundColor = UIColor(commonColor: isRead ? .appLightGray : .appGreen)
        notificationTextLabel.text = text
        dateTimeLabel.text = datetime.notificationsFormatted
    }
}

private extension Date {
    var notificationsFormatted: String {
        var date = "\(day()) \(months()) at \(time())"
        return date
    }
    
    func time() -> String {
        ""
    }
}

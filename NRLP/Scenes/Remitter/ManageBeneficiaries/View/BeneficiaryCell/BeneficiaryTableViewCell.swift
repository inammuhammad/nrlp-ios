//
//  BeneficiaryTableViewCell.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class BeneficiaryTableViewCell: UITableViewCell {

    @IBOutlet weak var forwardIconImageView: UIImageView!
    @IBOutlet private weak var fullNameLabel: UILabel! {
        didSet {
            fullNameLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regularOnlyEnglish, size: .mediumFontSize)
        }
    }
    @IBOutlet private weak var cnicLabel: UILabel! {
        didSet {
            cnicLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.lightOnlyEnglish, size: 11)
            cnicLabel.textColor = .black
        }
    }
    @IBOutlet private weak var statusLabel: UILabel! {
        didSet {
            statusLabel.textColor = .black
        }
    }
    @IBOutlet private weak var statusView: UIView! {
        didSet {
            statusView.cornerRadius = 5
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    private func setAsActive() {

        statusLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .smallFontSize)
        statusLabel.textColor = UIColor.init(commonColor: .appActiveText)
        statusLabel.textAlignment = .center
        statusView.backgroundColor = UIColor.init(commonColor: .appActiveBg)
        statusLabel.text = "Active".localized
    }

    private func setAsInactive() {
        statusLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .smallFontSize)
        statusLabel.textColor = UIColor.init(commonColor: .appInactiveText)
        statusLabel.textAlignment = .center
        statusView.backgroundColor = UIColor.init(commonColor: .appInactiveBg)
        statusLabel.text = "Pending".localized
    }

    private func setupUI() {

        setAsInactive()
        
        if AppConstants.appLanguage == .urdu && AppConstants.systemLanguage == .urdu {
            let icon = #imageLiteral(resourceName: "disclosure")
            forwardIconImageView.image = icon
            forwardIconImageView.transform.rotated(by: .pi)
        }
    }

    func populate(with beneficiary: BeneficiaryModel) {
        fullNameLabel.text = beneficiary.alias
        cnicLabel.text = beneficiary.formattedCNIC

        if beneficiary.isActive == 0 ? false : true {
            setAsActive()
        } else {
            setAsInactive()
        }

        self.layoutMargins = UIEdgeInsets.zero
    }
    
    func populate(with receiver: ReceiverModel) {
        fullNameLabel.text = receiver.receiverName
        cnicLabel.text = receiver.formattedReceiverCNIC

        if receiver.linkStatus?.lowercased() ?? "" == "ACTIVE".lowercased() {
            setAsActive()
        } else {
            setAsInactive()
        }

        self.layoutMargins = UIEdgeInsets.zero
    }

}

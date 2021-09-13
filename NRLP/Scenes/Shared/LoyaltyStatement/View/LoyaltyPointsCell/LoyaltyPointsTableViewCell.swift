//
//  LoyaltyPointsTableViewCell.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 15/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import UIKit

class LoyaltyPointsTableViewCell: UITableViewCell {

    @IBOutlet private weak var remittanceInfoLabel: UILabel! {
        didSet {
            remittanceInfoLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regularOnlyEnglish, size: .mediumFontSize)
        }
    }
    @IBOutlet private weak var dateLabel: UILabel! {
        didSet {
            dateLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.lightOnlyEnglish, size: 11)
            dateLabel.textColor = .black
        }
    }
    @IBOutlet private weak var transactionIDLabel: UILabel! {
        didSet {
            transactionIDLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.lightOnlyEnglish, size: 11)
            transactionIDLabel.textColor = .black
        }
    }
    @IBOutlet private weak var amountLabel: UILabel! {
        didSet {
            amountLabel.textColor = .black
        }
    }
    @IBOutlet private weak var statusView: UIView! {
        didSet {
            statusView.cornerRadius = 5
        }
    }
    
    private var viewModel: LoyaltyPointsTableCellViewModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    private func setAs(earned: Bool, amount: String) {

        if earned {
                amountLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .smallFontSize)
                amountLabel.textColor = UIColor.init(commonColor: .appActiveText)
                amountLabel.textAlignment = .center
                statusView.backgroundColor = UIColor.init(commonColor: .appActiveBg)
        } else {
                amountLabel.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .smallFontSize)
                amountLabel.textColor = UIColor.init(commonColor: .appRedeemText)
                amountLabel.textAlignment = .center
                statusView.backgroundColor = UIColor.init(commonColor: .appRedeemBg)
        }
        amountLabel.text = "\(amount) " + "points".localized
    }

    private func setupUI() {

        setAs(earned: true, amount: "12345")
    }

    func populate(with cellViewModel: LoyaltyPointsTableCellViewModel) {
        
        self.viewModel = cellViewModel
        remittanceInfoLabel.text = viewModel.infoTitle  //statement.status
        dateLabel.text = viewModel.getCreatedData()
        transactionIDLabel.text = viewModel.transactionIDTitle
        setAs(earned: viewModel.isEarned, amount: viewModel.formattedPoints)
        
        self.layoutMargins = UIEdgeInsets.zero

    }
}

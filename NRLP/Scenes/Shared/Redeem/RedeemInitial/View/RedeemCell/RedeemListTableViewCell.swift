import UIKit

class RedeemListTableViewCell: UITableViewCell {

    @IBOutlet private weak var lblName: UILabel! {
        didSet {
            lblName.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regularOnlyEnglish, size: .mediumFontSize)
            lblName.textColor = .black
        }
    }

    func populate(with partner: Partner) {
        lblName.text = partner.partnerName
        if AppConstants.isAppLanguageUrdu {
            lblName.textAlignment = .right
        } else {
            lblName.textAlignment = .left
        }
    }

}

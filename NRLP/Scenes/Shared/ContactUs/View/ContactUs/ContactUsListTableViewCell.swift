import UIKit

class ContactUsListTableViewCell: UITableViewCell {

    @IBOutlet private weak var lblName: UILabel! {
        didSet {
            lblName.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
            lblName.textColor = .black
        }
    }
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var contact: UILabel! {
        didSet {
            contact.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regular, size: .mediumFontSize)
            contact.textColor = UIColor(commonColor: .appGreen)
        }
    }
    
    func populate(with item: ContactItem) {
        lblName.text = item.title
        icon.image = item.image
        contact.text = item.displayContact
    }

}

import UIKit

class RedeemServiceViewController: BaseViewController {

    var viewModel: RedeemServiceViewModelProtocol!

    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet private weak var topContainerView: LoyaltyCardView!

    @IBOutlet private weak var lblEnterPoint: UILabel! {
        didSet {
            lblEnterPoint.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
        }
    }

    @IBOutlet private weak var inputViewEnterPoints: LabelledTextview! {
        didSet {
            inputViewEnterPoints.titleLabelText = "Enter Points".localized
            inputViewEnterPoints.placeholderText = "xxxx"
            inputViewEnterPoints.inputFieldMaxLength = 50
            inputViewEnterPoints.editTextKeyboardType = .asciiCapable
            inputViewEnterPoints.onTextFieldChanged = { updatedText in
                self.viewModel.points = updatedText
            }
        }
    }

    @IBOutlet private weak var btnNext: PrimaryCTAButton! {
        didSet {
            btnNext.setTitle("Next".localized, for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.bindViewModel()
        self.viewModel.viewDidLoad()
    }

    private func bindViewModel() {
        self.viewModel.output = { [unowned self] output in
            switch output {
            case .showActivityIndicator(let status):
                status ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                self.showAlert(with: error)
            case .nextButtonState(let enableState):
                self.btnNext.isEnabled = enableState
            case .showAlert(let alert):
                self.showAlert(with: alert)
            case .reloadViewData(let partnerName):
                self.tableView.reloadData()
                self.lblEnterPoint.text = String(format: "Select Redemption Service at %@".localized, partnerName)
            case .updateLoyaltyCard(let viewModel):
                self.topContainerView.populate(with: viewModel)
            case .navigateToFinishScreen(partner: let partner, transactionID: let transactionID):
                RedeemConfirmRouter(navigationController: self.navigationController).goToFinishScreen(transactionId: transactionID, partner: partner)
            }
        }
    }

    private func setupUI() {
        self.title = "Redeem".localized
        self.tableView.register(nibWithCellClass: RedeemServiceCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorInset = UIEdgeInsets.zero
    }
}

extension RedeemServiceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.categoryCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RedeemServiceCell") as! RedeemServiceCell
        cell.populate(with: self.viewModel.getCategory(index: indexPath.row), partner: self.viewModel.getPartner())
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.cellDidTap(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension RedeemServiceViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.redeemService
    }
}

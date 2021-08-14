import UIKit

class RedeemViewController: BaseViewController {

    var viewModel: RedeemViewModelProtocol!

    @IBOutlet private weak var lblMainTitle: UILabel! {
        didSet {
            self.lblMainTitle.text = "Redemption Partners".localized
            self.lblMainTitle.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
        }
    }

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.register(nibWithCellClass: RedeemListTableViewCell.self)
            self.tableView.tableFooterView = UIView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        self.bindViewModel()
        self.viewModel.viewDidLoad()
    }

    private func setupView() {
        self.title = "Redeem".localized
    }

    private func bindViewModel() {
        self.viewModel.output = { [unowned self] output in
            switch output {
            case .showActivityIndicator(let status):
                status ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                self.showAlert(with: error)
            case .dataReload:
                self.tableView.reloadData()
            }

        }
    }
}

extension RedeemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RedeemListTableViewCell.self, for: indexPath)
        cell.populate(with: viewModel.getPartner(index: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectOption(index: indexPath.row)
    }
}

extension RedeemViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.redeem
    }
}

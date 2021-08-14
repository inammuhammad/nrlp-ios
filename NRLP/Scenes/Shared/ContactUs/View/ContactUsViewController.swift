import UIKit

class ContactUsViewController: BaseViewController {

    var viewModel: ContactUsViewModelProtocol!

    @IBOutlet private weak var lblMainTitle: UILabel! {
        didSet {
            self.lblMainTitle.text = "Let’s keep in touch".localized
            self.lblMainTitle.font = UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.light, size: .mediumFontSize)
        }
    }

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.tableFooterView = UIView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        self.bindViewModel()
        self.viewModel.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.isUserInteractionEnabled = true
    }

    private func setupView() {
        self.title = "Contact Us".localized
        self.tableView.register(nibWithCellClass: ContactUsListTableViewCell.self)
    }

    private func bindViewModel() {
        self.viewModel.output = { [unowned self] output in
            switch output {
            case .showActivityIndicator(let status):
                status ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .dataReload:
                self.tableView.reloadData()
                self.view.isUserInteractionEnabled = true
            case .showError(let error):
                self.showAlert(with: error)
            }
        }
    }
}

extension ContactUsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ContactUsListTableViewCell.self, for: indexPath)
        cell.populate(with: viewModel.getItem(index: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.isUserInteractionEnabled = false
        viewModel.didSelectOption(index: indexPath.row)
    }
}

extension ContactUsViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.contactUs
    }
}

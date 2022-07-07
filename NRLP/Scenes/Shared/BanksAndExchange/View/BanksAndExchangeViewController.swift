//
//  BanksAndExchangeViewController.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 07/07/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import UIKit

typealias OnBankAndExchangeSelectionCallBack = (BanksAndExchange) -> Void

class BanksAndExchangeViewController: BaseViewController {
    
    var viewModel: BanksAndExchangeViewModel!
    var onBanksAndExchangeSelection: OnBankAndExchangeSelectionCallBack?
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            setupTableView()
        }
    }
    @IBOutlet private weak var progressBarView: ProgressBarView! {
        didSet {
            progressBarView.completedPercentage = 0.25
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.placeholder = "Search Banks & Exchange Company"
            searchBar.delegate = self
        }
    }
    
    private func registerNib() {
        tableView.register(nibWithCellClass: BranchListTableViewCell.self)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        registerNib()
    }
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModelOutput()
        viewModel.viewModelDidLoad()
    }
}

// MARK: BindViewModel and View binding
extension BanksAndExchangeViewController {
    private func bindViewModelOutput() {
        viewModel.output = {  [unowned self] output in
            switch output {
            case .reloadCountries:
                self.tableView.reloadData()
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                self.showAlert(with: error)
            case .hideProgressBar(let hide):
                self.progressBarView.isHidden = hide
            }
        }
    }
    
    private func setupView() {
        self.title = "Select Banks & Exchange Company".localized
        searchBar.barStyle = .default
        searchBar.setTextFieldBackgroundColor(UIColor.green)
        searchBar.setTextFieldFont(UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regularOnlyEnglish, size: .mediumFontSize))
    }
}

// MARK: UITableView Delegate & DataSource
extension BanksAndExchangeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: BranchListTableViewCell.self, for: indexPath)
        cell.populate(with: viewModel.getBanksAndExchange(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.endEditing(true)
        onBanksAndExchangeSelection?(viewModel.getBanksAndExchange(at: indexPath.row))
        viewModel.didSelectedBanksAndExchange()
    }
}

extension BanksAndExchangeViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        .banksAndExchange
    }
}

extension BanksAndExchangeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchTextDidChange(text: searchText)
        viewModel.isSearching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.isSearching = false
        self.searchBar.text = ""
        tableView.reloadData()
    }
}

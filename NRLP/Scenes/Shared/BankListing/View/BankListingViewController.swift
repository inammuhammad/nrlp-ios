//
//  BankListingViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 08/03/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import UIKit

typealias OnBankSelectionCallBack = (Banks) -> Void

class BankListingViewController: BaseViewController {

    var viewModel: BankListingViewModel!
    var onBankSelection: OnBankSelectionCallBack?
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            setupTableView()
        }
    }

    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.placeholder = "Search Bank"
            searchBar.delegate = self
        }
    }
    
    private func registerNib() {
        tableView.register(nibWithCellClass: CountryListTableViewCell.self)
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
extension BankListingViewController {
    private func bindViewModelOutput() {
        viewModel.output = {  [unowned self] output in
            switch output {
            case .reloadBanks:
                self.tableView.reloadData()
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                self.showAlert(with: error)
            }
        }
    }
    
    private func setupView() {
        self.title = "Select Bank".localized
        searchBar.barStyle = .default
        searchBar.setTextFieldBackgroundColor(UIColor.green)
        searchBar.setTextFieldFont(UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regularOnlyEnglish, size: .mediumFontSize))
    }
}

// MARK: UITableView Delegate & DataSource
extension BankListingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CountryListTableViewCell.self, for: indexPath)
        cell.populate(with: viewModel.getBankName(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.endEditing(true)
        onBankSelection?(viewModel.getBankName(at: indexPath.row))
        viewModel.didSelectBanks()
    }
}

extension BankListingViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.bankListing
    }
}

extension BankListingViewController: UISearchBarDelegate {
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

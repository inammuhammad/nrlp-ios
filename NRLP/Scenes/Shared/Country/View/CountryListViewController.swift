//
//  CountryListViewController.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

typealias OnCountrySelectionCallBack = (Country) -> Void

class CountryListViewController: BaseViewController {
    
    var viewModel: CountryListViewModel!
    var onCountrySelection: OnCountrySelectionCallBack?
    
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
            searchBar.placeholder = "Search Country"
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
extension CountryListViewController {
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
        self.title = "Select Country".localized
        searchBar.barStyle = .default
        searchBar.setTextFieldBackgroundColor(UIColor.green)
        searchBar.setTextFieldFont(UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regularOnlyEnglish, size: .mediumFontSize))
    }
}

// MARK: UITableView Delegate & DataSource
extension CountryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CountryListTableViewCell.self, for: indexPath)
        cell.populate(with: viewModel.getCountryName(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.endEditing(true)
        onCountrySelection?(viewModel.getCountryName(at: indexPath.row))
        viewModel.didSelectedCountry()
    }
}

extension CountryListViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.countryList
    }
}

extension CountryListViewController: UISearchBarDelegate {
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

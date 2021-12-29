//
//  CityListViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 28/12/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import UIKit

typealias OnCitySelectionCallBack = (Cities) -> Void

class CityListViewController: BaseViewController {
    
    var viewModel: CityListViewModel!
    var onCitySelection: OnCitySelectionCallBack?
    
    @IBOutlet weak var loadMoreButton: PrimaryCTAButton! {
        didSet {
            loadMoreButton.setTitle("Load More".localized, for: .normal)
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.placeholder = "Search City"
            searchBar.delegate = self
        }
    }
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            setupTableView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModelOutput()
        viewModel.viewModelDidLoad()
    }
    
    private func setupView() {
        self.title = "Select City".localized
        searchBar.barStyle = .default
        searchBar.setTextFieldBackgroundColor(UIColor.green)
        searchBar.setTextFieldFont(UIFont.init(commonFont: CommonFont.HpSimplifiedFontStyle.regularOnlyEnglish, size: .mediumFontSize))
    }
    
    private func registerNib() {
        tableView.register(nibWithCellClass: CityListTableViewCell.self)
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.registerNib()
    }
    
    private func bindViewModelOutput() {
        self.viewModel.output = {  [unowned self] output in
            switch output {
            case .reloadCities:
                self.tableView.reloadData()
            case .showActivityIndicator(let show):
                show ? ProgressHUD.show() : ProgressHUD.dismiss()
            case .showError(let error):
                self.showAlert(with: error)
            case .loadMoreButton(enable: let enable):
                self.loadMoreButton.isEnabled = enable
            }
        }
    }
    
    @IBAction private func loadMoreButtonAction (_ sender: Any) {
        viewModel.loadMoreButtonPressed()
    }
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CityListTableViewCell.self, for: indexPath)
        cell.populate(with: viewModel.getCity(at: indexPath.row).city)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.endEditing(true)
        onCitySelection?(viewModel.getCity(at: indexPath.row))
        viewModel.didSelectCity()
    }
}

extension CityListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        viewModel.searchText = searchBar.text ?? ""
        viewModel.searchButtonPressed(text: searchBar.text ?? "")
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        viewModel.searchCancelled()
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.searchCancelled()
            tableView.reloadData()
        }
    }
}

extension CityListViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.cityList
    }
}

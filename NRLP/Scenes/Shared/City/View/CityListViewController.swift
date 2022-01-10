//
//  CityListViewController.swift
//  NRLP
//
//  Created by Bilal Iqbal on 28/12/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import UIKit

typealias OnCitySelectionCallBack = (String) -> Void

class CityListViewController: BaseViewController {
    
    var viewModel: CityListViewModel!
    var onCitySelection: OnCitySelectionCallBack?
    
    @IBOutlet weak var othersBtn: PrimaryCTAButton! {
        didSet {
            othersBtn.setTitle("Others".localized, for: .normal)
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
        self.title = "Place of Birth".localized
        self.othersBtn.isHidden = true
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
            case .showAlert(alert: let alert):
                self.showAlert(with: alert)
            case .enteredCity(city: let text):
                onCitySelection?(text)
                viewModel.didSelectCity()
            }
        }
    }
    
    @IBAction func othersBtnAction(_ sender: Any) {
        viewModel.othersButtonPressed()
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
        if viewModel.getCity(at: indexPath.row).city.lowercased() == "Other".lowercased() {
            viewModel.othersButtonPressed()
            return
        }
        onCitySelection?(viewModel.getCity(at: indexPath.row).city)
        viewModel.didSelectCity()
    }
}

extension CityListViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.isSearching = false
        self.searchBar.text = ""
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchTextDidChange(text: searchText)
        viewModel.isSearching = true
        tableView.reloadData()
    }
}

extension CityListViewController: Initializable {
    static var storyboardName: UIStoryboard.Name {
        return UIStoryboard.Name.cityList
    }
}

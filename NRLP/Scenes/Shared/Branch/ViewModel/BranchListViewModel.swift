//
//  BranchListViewModel.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 05/07/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import Foundation

typealias BranchListViewModelOutput = (BranchListViewModel.Output) -> Void

protocol BranchListViewModelProtocol {
    var output: CountryViewModelOutput? { get set }
    var numberOfRows: Int { get }
    var isSearching: Bool? { get set }
    var pseName: String { get set }
    
    func searchTextDidChange(text: String)
    func viewModelDidLoad()
    func getBranch(at index: Int) -> Branch
    func didSelectedBranch()
}

class BranchListViewModel: BranchListViewModelProtocol {
    var pseName: String
    
    var isSearching: Bool?

    var output: CountryViewModelOutput?
    private var router: BranchListRouter!
    private var service: BranchListServiceProtocol!
    private var hideProgressBar: Bool!

    private var branches: [Branch] = []
    private var filteredBranches: [Branch] = []

    init(with service: BranchListService = BranchListService(),
         router: BranchListRouter,
         hideProgressBar: Bool, pseName: String) {
        self.service = service
        self.router = router
        self.hideProgressBar = hideProgressBar
        self.pseName = pseName
    }

    func viewModelDidLoad() {
        fetchBranches()
        output?(.hideProgressBar(hide: hideProgressBar))
    }

    private func fetchBranches() {
        output?(.showActivityIndicator(show: true))
        service.fetchBranches(pseName: pseName) { [weak self] (result) in

            guard let self = self else { return }

            self.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let branchResponse):
                self.branches = branchResponse.data.sorted(by: { $0.countryName < $1.countryName })
                self.output?(.reloadCountries)
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        }
    }

    func didSelectedBranch() {
        router.popToPreviousScreen()
    }
    
    func searchTextDidChange(text: String) {
        filteredBranches = branches.filter { $0.countryName.starts(with: text) }
    }

    enum Output {
        case showError(error: APIResponseError)
        case showActivityIndicator(show: Bool)
        case reloadCountries
        case hideProgressBar(hide: Bool)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

// MARK: DataSource related methods
extension BranchListViewModel {
    var numberOfRows: Int {
        if isSearching ?? false {
            return filteredBranches.count
        }
        return branches.count
    }

    func getBranch(at index: Int) -> Branch {
        if isSearching ?? false {
            return filteredBranches[index]
        }
        return branches[index]
    }
}

//
//  BankListinViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 08/03/2022.
//  Copyright © 2022 VentureDive. All rights reserved.
//

import Foundation

typealias BankListingViewModelOutput = (BankListingViewModel.Output) -> Void

protocol BankListingViewModelProtocol {
    var output: BankListingViewModelOutput? { get set }
    var numberOfRows: Int { get }
    var isSearching: Bool? { get set }
    
    func searchTextDidChange(text: String)
    func viewModelDidLoad()
    func getBankName(at index: Int) -> Banks
    func didSelectBanks()
}

class BankListingViewModel: BankListingViewModelProtocol {
    
    var isSearching: Bool?

    var output: BankListingViewModelOutput?
    private var router: BankListingRouter!
    private var bankListingService: BankListingService!

    private var banks: [Banks] = []
    private var filteredBanks: [Banks] = []

    init(with service: BankListingService = BankListingService(),
         router: BankListingRouter) {
        self.bankListingService = service
        self.router = router
    }

    func viewModelDidLoad() {
        fetchBanks()
    }

    private func fetchBanks() {
        output?(.showActivityIndicator(show: true))
        bankListingService.fetchBanks { [weak self] (result) in
            guard let self = self else { return }
            
            self.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let bankResponse):
                self.banks = (bankResponse.data ?? []).sorted(by: { $0.name < $1.name })
                self.output?(.reloadBanks)
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        }
    }

    func didSelectBanks() {
        router.popToPreviousScreen()
    }
    
    func searchTextDidChange(text: String) {
        filteredBanks = banks.filter { $0.name.starts(with: text) }
    }

    enum Output {
        case showError(error: APIResponseError)
        case showActivityIndicator(show: Bool)
        case reloadBanks
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

// MARK: DataSource related methods
extension BankListingViewModel {
    var numberOfRows: Int {
        if isSearching ?? false {
            return filteredBanks.count
        }
        return banks.count
    }

    func getBankName(at index: Int) -> Banks {
        if isSearching ?? false {
            return filteredBanks[index]
        }
        return banks[index]
    }
}

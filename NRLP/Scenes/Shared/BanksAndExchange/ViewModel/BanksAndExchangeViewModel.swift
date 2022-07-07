//
//  BanksAndExchangeViewModel.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 07/07/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import Foundation

typealias BanksAndExchangeViewModelOutput = (BanksAndExchangeViewModel.Output) -> Void

protocol BanksAndExchangeViewModelProtocol {
    var output: BanksAndExchangeViewModelOutput? { get set }
    var numberOfRows: Int { get }
    var isSearching: Bool? { get set }
    
    func searchTextDidChange(text: String)
    func viewModelDidLoad()
    func getBanksAndExchange(at index: Int) -> BanksAndExchange
    func didSelectedBanksAndExchange()
}

class BanksAndExchangeViewModel: BanksAndExchangeViewModelProtocol {
    
    var isSearching: Bool?
    
    var output: BanksAndExchangeViewModelOutput?
    private var router: BanksAndExchangeRouter!
    private var hideProgressBar: Bool!
    
    private var banksAndExchanges: [String] = [
        "Allied Bank Limited",
        "Askari Bank Limited",
        "Al Baraka Bank Pakistan",
        "BankIslami Pakistan Limited",
        "Bank of Khyber",
        "JS Bank Limited",
        "Khushhali Microfinance Bank Limited",
        "MCB Islamic Bank",
        "Mobilink Microfinance Bank Pvt. Ltd",
        "National Bank of Pakistan",
        "Silkbank Limited",
        "Sindh Bank Limited",
        "Soneri Bank Limited",
        "Summit Bank",
        "Bank Alfalah Limited",
        "Bank Al Habib Limited",
        "Bank of Punjab",
        "Dubai Islamic Bank",
        "Faysal Bank Limited",
        "Habib Metropolitan Bank",
        "Habib Bank Limited",
        "MCB Bank Limited",
        "Meezan Bank",
        "Samba Bank Limited",
        "Standard Chartered Pakistan",
        "United Bank Limited",
        "Telenor Microfinance Bank",
        "Zarai Taraqiati Bank Limited",
        "U Microfinance Bank Limited",
        "AA Exchange Company (Pvt.) Ltd",
        "D.D Exchange Company (Pvt.) Ltd",
        "Dollar East Exchange Company",
        "Fairdeal Exchange Company (Pvt) Limited",
        "H&H Exchange Co (Pvt.) Ltd",
        "Habib Qatar International Exchange Pakistan (Pvt.) Ltd",
        "Link International Exchange Co Pvt Ltd",
        "Muhammadi Exchange Company (Pvt) Limited",
        "NBP Exchange Company Limited",
        "Pakistan Currency Exchange (Pvt) Ltd",
        "Paracha International Exchange Pvt Ltd",
        "Paragon Exchange Private Limited",
        "Ravi Exchange Company pvt ltd",
        "Royal International Exchange Co, (Pvt) Ltd",
        "Sadiq Exchange Company (Pvt) Ltd",
        "Sky Exchange Company - Pvt Ltd",
        "Wall Street Exchange Company (PVT) Limited",
        "ZeeQue Exchange Company (Pvt) Ltd"
    ]
    private var filteredBanksAndExchanges: [String] = []
    
    init(router: BanksAndExchangeRouter,
         hideProgressBar: Bool) {
        self.router = router
        self.hideProgressBar = hideProgressBar
    }
    
    func viewModelDidLoad() {
//        fetchBranches()
//        output?(.hideProgressBar(hide: hideProgressBar))
    }
    
    private func fetchBranches() {
        //        output?(.showActivityIndicator(show: true))
        //        service.fetchBranches(pseName: pseName) { [weak self] (result) in
        //
        //            guard let self = self else { return }
        //
        //            self.output?(.showActivityIndicator(show: false))
        //            switch result {
        //            case .success(let branchResponse):
        //                self.branches = branchResponse.data.sorted(by: { $0.countryName < $1.countryName })
        //                self.output?(.reloadCountries)
        //            case .failure(let error):
        //                self.output?(.showError(error: error))
        //            }
        //        }
    }
    
    func didSelectedBanksAndExchange() {
        router.popToPreviousScreen()
    }
    
    func searchTextDidChange(text: String) {
        filteredBanksAndExchanges = banksAndExchanges.filter { $0.starts(with: text) }
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
extension BanksAndExchangeViewModel {
    var numberOfRows: Int {
        if isSearching ?? false {
            return filteredBanksAndExchanges.count
        }
        return banksAndExchanges.count
    }
    
    func getBanksAndExchange(at index: Int) -> BanksAndExchange {
        if isSearching ?? false {
            return BanksAndExchange(name: filteredBanksAndExchanges[index])
        }
        return BanksAndExchange(name: banksAndExchanges[index])
    }
}

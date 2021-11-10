//
//  CountryListScreenViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias CountryViewModelOutput = (CountryListViewModel.Output) -> Void

protocol CountryListViewModelProtocol {
    var output: CountryViewModelOutput? { get set }
    var numberOfRows: Int { get }
    var isSearching: Bool? { get set }
    var accountType: AccountType? { get set }
    
    func searchTextDidChange(text: String)
    func viewModelDidLoad()
    func getCountryName(at index: Int) -> Country
    func didSelectedCountry()
}

class CountryListViewModel: CountryListViewModelProtocol {
    var accountType: AccountType?
    
    var isSearching: Bool?

    var output: CountryViewModelOutput?
    private var router: CountryListRouter!
    private var countryService: CountryService!
    private var hideProgressBar: Bool!

    private var countries: [Country] = []
    private var filteredCountries: [Country] = []

    init(with service: CountryService = CountryService(),
         router: CountryListRouter,
         hideProgressBar: Bool, userType: AccountType?) {
        self.countryService = service
        self.router = router
        self.hideProgressBar = hideProgressBar
        self.accountType = userType
    }

    func viewModelDidLoad() {
        fetchCountries()
        output?(.hideProgressBar(hide: hideProgressBar))
    }

    private func fetchCountries() {
        output?(.showActivityIndicator(show: true))
        countryService.fetchCountries(accountType: self.accountType) { [weak self] (result) in

            guard let self = self else { return }

            self.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let countryResponse):
                self.countries = (countryResponse.data ?? []).sorted(by: { $0.country < $1.country })
                self.output?(.reloadCountries)
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        }
    }

    func didSelectedCountry() {
        router.popToPreviousScreen()
    }
    
    func searchTextDidChange(text: String) {
        filteredCountries = countries.filter { $0.country.starts(with: text) }
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
extension CountryListViewModel {
    var numberOfRows: Int {
        if isSearching ?? false {
            return filteredCountries.count
        }
        return countries.count
    }

    func getCountryName(at index: Int) -> Country {
        if isSearching ?? false {
            return filteredCountries[index]
        }
        return countries[index]
    }
}

//
//  CityListViewModel.swift
//  NRLP
//
//  Created by Bilal Iqbal on 28/12/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

typealias CityViewModelOutput = (CityListViewModel.Output) -> Void

protocol CityListViewModelProtocol {
    var output: CityViewModelOutput? { get set }
    var numberOfRows: Int { get }
    
    func searchButtonPressed(text: String)
    func searchCancelled()
    func viewModelDidLoad()
    func getCity(at index: Int) -> Cities
    func didSelectCity()
    func loadMoreButtonPressed()
}

class CityListViewModel: CityListViewModelProtocol {
    
    var pageNumber: Int = 0
    var searchText: String = ""
    
    func loadMoreButtonPressed() {
        pageNumber += 1
        fetchCities(text: searchText, page: pageNumber)
    }
    
    var cities: [Cities] = []
    
    var output: CityViewModelOutput?
    private var service: CityService!
    private var router: CityListRouter!
    
    var numberOfRows: Int {
        return self.cities.count
    }
    
    func searchButtonPressed(text: String) {
        self.output?(.loadMoreButton(enable: false))
        self.cities = []
        pageNumber = 0
        self.fetchCities(text: text, page: pageNumber)
    }
    
    func searchCancelled() {
        self.output?(.loadMoreButton(enable: false))
        self.cities = []
        pageNumber = 0
        searchText = ""
        self.fetchCities(text: searchText, page: pageNumber)
    }
    
    init(with service: CityService = CityService(),
         router: CityListRouter) {
        self.service = service
        self.router = router
    }
    
    func viewModelDidLoad() {
        fetchCities(text: "", page: 0)
    }
    
    func getCity(at index: Int) -> Cities {
        return cities[index]
    }
    
    func didSelectCity() {
        router.popToPreviousScreen()
    }
    
    private func fetchCities(text: String, page: Int) {
        output?(.showActivityIndicator(show: true))
        service.fetchCities(text: text, page: page) { [weak self] (result) in
            guard let self = self else { return }
            self.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let cityResponse):
                if let citiesData = cityResponse.data {
                    if citiesData.isEmpty {
                        self.output?(.loadMoreButton(enable: false))
                        return
                    }
                    self.output?(.loadMoreButton(enable: true))
                    let arr = citiesData.sorted(by: { $0.city < $1.city })
                    for city in arr {
                        self.cities.append(city)
                    }
                    self.output?(.reloadCities)
                } else {
                    self.output?(.loadMoreButton(enable: false))
                }
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        }
    }
    
    enum Output {
        case showError(error: APIResponseError)
        case showActivityIndicator(show: Bool)
        case reloadCities
        case loadMoreButton(enable: Bool)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

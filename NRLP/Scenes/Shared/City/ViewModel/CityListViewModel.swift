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
    var isSearching: Bool? { get set }
    
    func searchTextDidChange(text: String)
    func viewModelDidLoad()
    func getCity(at index: Int) -> Cities
    func didSelectCity()
    func othersButtonPressed()
}

class CityListViewModel: CityListViewModelProtocol {
    
    var cities: [Cities] = []
    var filteredCities: [Cities] = []
    var isSearching: Bool?
    
    var output: CityViewModelOutput?
    private var service: CityService!
    private var router: CityListRouter!
    
    var numberOfRows: Int {
        if isSearching ?? false {
            return self.filteredCities.count
        }
        return self.cities.count
    }
    
    func othersButtonPressed() {
        //Show alert with textfield
        var cityText = ""
        let textFieldModel = AlertTextFieldModel(titleLabelText: "", placeholderText: "Lahore", inputText: nil, inputFieldMaxLength: 30, inputFieldMinLength: 1, editKeyboardType: .asciiCapable, formatValidator: nil, formatter: nil, onTextFieldChanged: { text in
            cityText = text
        }, errorMessage: "Please enter valid city name")
        let buttonModel = AlertActionButtonModel(buttonTitle: "Confirm".localized, buttonAction: {
            self.output?(.enteredCity(city: cityText))
        })
        let cancelButtonModel = AlertActionButtonModel(buttonTitle: "Cancel".localized, buttonAction: {
        })
        let alertViewModel = AlertViewModel(alertHeadingImage: .noImage, alertTitle: "Place of Birth".localized, alertDescription: "", alertAttributedDescription: nil, primaryButton: buttonModel, secondaryButton: cancelButtonModel, topTextField: textFieldModel)
        self.output?(.showAlert(alert: alertViewModel))
    }
    
    private func showEmptyCityError() {
        let alert = AlertViewModel(alertHeadingImage: .errorAlert, alertTitle: "Error".localized, alertDescription: "City name can not be empty".localized, primaryButton: AlertActionButtonModel(buttonTitle: "OK".localized))
        self.output?(.showAlert(alert: alert))
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
        if isSearching ?? false {
            return filteredCities[index]
        }
        return cities[index]
    }
    
    func didSelectCity() {
        router.popToPreviousScreen()
    }
    
    func searchTextDidChange(text: String) {
        filteredCities = cities.filter { $0.city.starts(with: text) }
    }
    
    private func fetchCities(text: String, page: Int) {
        output?(.showActivityIndicator(show: true))
        service.fetchCities(text: text, page: page) { [weak self] (result) in
            guard let self = self else { return }
            self.output?(.showActivityIndicator(show: false))
            switch result {
            case .success(let cityResponse):
                if let citiesData = cityResponse.data {
                    let arr = citiesData.sorted(by: { $0.city < $1.city })
                    for city in arr {
                        self.cities.append(city)
                    }
                    self.cities.append(Cities(city: "Other", id: 0, createdAt: "", updatedAt: "", isActive: 0, isDeleted: 0))
                    self.output?(.reloadCities)
                }
            case .failure(let error):
                self.output?(.showError(error: error))
            }
        }
    }
    
    enum Output {
        case showError(error: APIResponseError)
        case showActivityIndicator(show: Bool)
        case showAlert(alert: AlertViewModel)
        case reloadCities
        case enteredCity(city: String)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

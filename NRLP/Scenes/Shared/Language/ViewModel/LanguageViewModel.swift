//
//  LanguageViewModel.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 10/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias LanguageViewModelOutput = (LanguageViewModel.Output) -> Void

protocol LanguageViewModelProtocol {
    var output: LanguageViewModelOutput? {get set}
    var languageItemModel: [RadioButtonItemModel] { get }
    var selectedLanguage: String? {get set}
    func confirmLanguageUpdate()
    func viewModelDidLoad()
    func didTapSaveButton()
}

class LanguageViewModel: LanguageViewModelProtocol {
    
    var currentLanguage: AppLanguage?
    var output: LanguageViewModelOutput?
    var languageItemModel: [RadioButtonItemModel] = []
    var user: UserModel?
    
    private var router: LanguageRouter?
    
    var selectedLanguage: String? {
        didSet {
            if let selectedLang = AppLanguage(rawValue: selectedLanguage ?? "") {
                self.output?(.nextButtonState(enabled: selectedLang != currentLanguage))
            }
        }
    }
    
    init(router: LanguageRouter,
         user: UserModel?) {
        self.currentLanguage = NRLPUserDefaults.shared.getSelectedLanguage()
        self.router = router
        self.user = user
        setupLanguages()
    }
    
    func viewModelDidLoad() {
        if currentLanguage == nil {
            self.output?(.setCurrentLanguageSelected(index: AppConstants.systemLanguage == .urdu ? 1 : 0))
        } else {
            self.output?(.setCurrentLanguageSelected(index: currentLanguage == .urdu ? 1 : 0))
        }
    }
    
    func confirmLanguageUpdate() {
        if let selectedLanguage = selectedLanguage,
            let language = AppLanguage(rawValue: selectedLanguage) {
            NRLPUserDefaults.shared.set(selectedLanguage: language)
            navigateToFlowRoot()
        }
    }
    
    private func navigateToFlowRoot() {
        if let rootItem = router?.getRootNavigationItem(),
            rootItem is HomeViewController,
            let user = user {
            router?.navigateToHomeView(for: user)
        } else {
            router?.navigateToLoginView()
        }
    }
    
    private func setupLanguages() {
        languageItemModel = [
            RadioButtonItemModel(title: AppLanguage.english.title, key: AppLanguage.english.rawValue, itemStyle: .labelBeforeImage),
            RadioButtonItemModel(title: AppLanguage.urdu.title, key: AppLanguage.urdu.rawValue, itemStyle: .labelBeforeImage)
        ]
        selectedLanguage = languageItemModel.first?.key
    }
    
    func didTapSaveButton() {
        if NRLPUserDefaults.shared.cachedSelectedLanguage == nil {
            self.confirmLanguageUpdate()
            return
        }
        let alert = AlertViewModel(alertHeadingImage: .languageChange, alertTitle: "Language Selection".localized, alertDescription: "Application has monitored a change in language, continuing with it will restart the application. Do you want to continue?".localized, alertAttributedDescription: nil, primaryButton: AlertActionButtonModel(buttonTitle: "Confirm".localized, buttonAction: {
            self.confirmLanguageUpdate()
        }), secondaryButton: AlertActionButtonModel(buttonTitle: "Cancel".localized, buttonAction: nil))
        output?(.showAlert(viewModel: alert))
    }
    
    enum Output {
        case showAlert(viewModel: AlertViewModel)
        case nextButtonState(enabled: Bool)
        case setCurrentLanguageSelected(index: Int)
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

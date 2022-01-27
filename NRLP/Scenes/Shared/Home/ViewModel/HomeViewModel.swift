//
//  HomeViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias HomeViewModelOutput = (HomeViewModel.Output) -> Void

protocol HomeViewModelProtocol {

    var output: HomeViewModelOutput? { get set }
    var numberOfItems: Int { get }
    var getTitleName: String { get }

    func viewModelWillAppear()
    func viewModelDidLoad()
    func getItem(at index: Int) -> HomeCollectionViewCellDataModelProtocol
    func didTapItem(at index: Int)
    func didTapSideMenu(item: SideMenuItem)
    func getUserModel() -> UserModel
}

class HomeViewModel: HomeViewModelProtocol {
    func getUserModel() -> UserModel {
        return userModel
    }
    
    var getTitleName: String {
        return userModel.fullName
    }
    var numberOfItems: Int {
        return collectionViewItemData.count
    }
    private(set) var router: HomeRouter
    var output: HomeViewModelOutput?
    private var userProfileService: UserProfileServiceProtocol!
    private var logoutService: LogoutServiceProtocol
    internal var collectionViewItemData: [HomeCollectionViewCellDataModelProtocol] = []

    var userModel: UserModel

    init(with userModel: UserModel,
         router: HomeRouter,
         userProfileService: UserProfileServiceProtocol = UserProfileService(),
         logoutService: LogoutServiceProtocol = LogoutService()) {
        self.userModel = userModel
        self.router = router
        self.userProfileService = userProfileService
        self.logoutService = logoutService
    }

    func viewModelDidLoad() {
        setupCollectionViewData()
        output?(.reloadCollectionView)
    }

    func viewModelWillAppear() {
        fetchUserProfile() // Throws error
    }

    private func fetchUserProfile() {
        userProfileService.getUserProfile { [weak self] (response) in
            switch response {
            case .success(let response):
                if let data = response.data {
                    self?.userModel.update(from: data)
                    self?.checkNadraVerificationStatus()
                    self?.setupCollectionViewData()
                    self?.output?(.reloadCollectionView)
                }
            case .failure(let error):
                print("Request Fail With Error: \(error)")
//                self?.output?(.showError(error: error))
            }
        }
    }

    internal func setupCollectionViewData() {
        self.collectionViewItemData = [
            HomeCollectionViewLoyaltyCellDataModel(with: "\(Int(userModel.roundedLoyaltyPoints) )", loyaltyType: userModel.loyaltyLevel, user: userModel, remittedDate: userModel.memberSince ?? "", remittedAmount: ("USD " + (userModel.formattedUsdBalance)))
        ]
    }

    func getItem(at index: Int) -> HomeCollectionViewCellDataModelProtocol {
        return collectionViewItemData[index]
    }

    func didTapItem(at index: Int) {
//        if AppConstants.isDev {
            router.navigateToLoyaltyScreen(user: userModel)
//        }
//        showComingSoonAlert()
    }

    func showComingSoonAlert() {
        output?(.showAlert(alertModel: AlertViewModel(alertHeadingImage: .comingSoon, alertTitle: "Coming Soon".localized, alertDescription: "This feature is coming very soon".localized, alertAttributedDescription: nil, primaryButton: AlertActionButtonModel(buttonTitle: "Okay".localized, buttonAction: nil), secondaryButton: nil)))
    }
    
    func didTapSideMenu(item: SideMenuItem) {
        switch item {
        case .changePassword:
            router.navigateToChangePassword()
        case .logout:
            shouldLogout()
        case .languageSelection:
            router.navigateToLanguageChange(user: userModel)
        case .faqs:
            router.navigateToFaqs()
        case .profile:
            router.navigateToProfile()
        case .contactUs:
            router.navigateToContactUs()
        case .complaint:
            if let type = self.userModel.accountType {
                router.navigateToComplaintManagement(userType: type)
            }
        case .guide:
            router.navigateToGuide(link: "https://www.youtube.com/playlist?list=PLFB-5JvOR9rAvAGK6YzQmxXvFiUWn48vY") { errorText in
                let errorModel = AlertViewModel(alertHeadingImage: .ohSnap, alertTitle: StringConstants.ErrorString.serverErrorTitle.localized, alertDescription: errorText, primaryButton: AlertActionButtonModel(buttonTitle: "Okay".localized, buttonAction: nil))
                output?(.showLogoutAlert(alertModel: errorModel))
            }
        }
    }

    private func shouldLogout() {
        let viewModel = AlertViewModel(alertHeadingImage: .ohSnap, alertTitle: "Logout".localized, alertDescription: "Are you sure you want to Logout?".localized, alertAttributedDescription: nil, primaryButton: AlertActionButtonModel(buttonTitle: "Confirm".localized, buttonAction: { [weak self] in
            self?.logoutUser()
        }), secondaryButton: AlertActionButtonModel(buttonTitle: "Cancel".localized, buttonAction: nil))

        output?(.showLogoutAlert(alertModel: viewModel))
    }

    private func logoutUser() {
        output?(.showActivityIndicator(show: true))
        logoutService.logoutUser { [weak self] (_) in
            guard let self = self else { return }
            self.output?(.showActivityIndicator(show: false))
            self.router.navigateToLoginScreen()
        }
    }

    func didTapLogout() {
        output?(.showError(error: .internetOffline))
    }
    
    private func checkNadraVerificationStatus() {
        if userModel.requiresNadraVerification ?? false {
            router.navigateToNadraVerificationScreen(userModel: self.userModel)
        }
    }

    enum Output {
        case reloadCollectionView
        case showActivityIndicator(show: Bool)
        case showError(error: APIResponseError)
        case showLogoutAlert(alertModel: AlertViewModel)
        case showAlert(alertModel: AlertViewModel)
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

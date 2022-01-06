//
//  SideMenuViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 15/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias SideMenuViewModelOutput = (SideMenuViewModel.Output) -> Void

protocol SideMenuViewModelProtocol {
    var numberOfItems: Int { get }
    var output: SideMenuViewModelOutput? { get set }
    var sectionHeaderModel: SideMenuTableHeaderViewModel { mutating get }

    func getItem(at index: Int) -> SideMenuItem
    func didTapItem(at index: Int)
    func viewModelDidLoad()
}

struct SideMenuViewModel: SideMenuViewModelProtocol {

    private var items: [SideMenuItem]
    var output: SideMenuViewModelOutput?
    private var userModel: UserModel

    var numberOfItems: Int {
        return items.count
    }

    var versionNumber: String {
        return "Version".localized + " \(AppConstants.sideMenuVersionNumber)-\(AppConstants.buildNumber)"
    }

    lazy var sectionHeaderModel: SideMenuTableHeaderViewModel = SideMenuTableHeaderViewModel(name: userModel.fullName, cnic: "\(userModel.cnicNicop)")

    init(with userModel: UserModel) {
        items = [
            .profile,
            .changePassword,
            .faqs,
            .guide,
            .languageSelection,
            .contactUs,
            .logout
        ]
        self.userModel = userModel
    }

    func getItem(at index: Int) -> SideMenuItem {
        return items[index]
    }

    func didTapItem(at index: Int) {
        if let item = SideMenuItem(rawValue: index) {
            output?(.navigateToSection(item: item))
        }
    }

    func viewModelDidLoad() {
        output?(.updateVersionNumber(version: versionNumber))
    }

    enum Output {
        case navigateToSection(item: SideMenuItem)
        case updateVersionNumber(version: String)
    }
}

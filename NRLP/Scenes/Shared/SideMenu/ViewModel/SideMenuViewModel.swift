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
            .complaint,
            .logout
        ]
        
        if userModel.accountType == .remitter {
            items.insert(.receiverManagement, at: 2)
        }
        
        self.userModel = userModel
    }

    func getItem(at index: Int) -> SideMenuItem {
        return items[index]
    }

    func didTapItem(at index: Int) {
        var index = index
        
        if userModel.accountType == .beneficiary {
            // for all above 1 add 1
            if index > 1 {
                index += 1
            }
        }
        
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

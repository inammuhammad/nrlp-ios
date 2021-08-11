//
//  RemitterHomeViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

class RemitterHomeViewModel: HomeViewModel {

    override func setupCollectionViewData() {
        super.setupCollectionViewData()

        if AppConstants.appLanguage == .english {
            setupDataForEnglish()
        } else {
            setupDataForUrdu()
        }
    }
    
    private func setupDataForUrdu() {
        collectionViewItemData.append(HomeCollectionViewCardCellDataModel(with: .managePoints))
        collectionViewItemData.append(HomeCollectionViewCardCellDataModel(with: .manageBeneficiary))
        collectionViewItemData.append(HomeCollectionViewCardCellDataModel(with: .nrlpBenefits))
        collectionViewItemData.append(HomeCollectionViewCardCellDataModel(with: .viewStatement))
    }
    
    private func setupDataForEnglish() {
        collectionViewItemData.append(HomeCollectionViewCardCellDataModel(with: .manageBeneficiary))
        collectionViewItemData.append(HomeCollectionViewCardCellDataModel(with: .managePoints))
        collectionViewItemData.append(HomeCollectionViewCardCellDataModel(with: .viewStatement))
        collectionViewItemData.append(HomeCollectionViewCardCellDataModel(with: .nrlpBenefits))
    }

    override func didTapItem(at index: Int) {
        let model = getItem(at: index)
        switch model.cardType {
        case .loyalty:
            super.didTapItem(at: index)
        case .manageBeneficiary:
            router.navigateToManageBeneficiariesScreen(userModel: userModel)
        case .managePoints:
            router.navigateToManagePointsScreen(userModel: userModel)
        case .viewStatement:
            router.navigateToViewStatement(userModel: userModel)
        case .nrlpBenefits:
          // router.navigateToNRLPBenefits()
            showComingSoonAlert()
        }
    }

    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

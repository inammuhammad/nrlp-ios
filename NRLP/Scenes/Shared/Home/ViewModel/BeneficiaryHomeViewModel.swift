//
//  BeneficiaryHomeViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

class BeneficiaryHomeViewModel: HomeViewModel {
    
    override func setupCollectionViewData() {
        super.setupCollectionViewData()
        
        if AppConstants.appLanguage == .english {
            setupDataForEnglish()
        } else {
            setupDataForUrdu()
        }
    }
    
    private func setupDataForUrdu() {
        collectionViewItemData.append(HomeCollectionViewCardCellDataModel(with: .redemption))
        collectionViewItemData.append(HomeCollectionViewCardCellDataModel(with: .nrlpBenefits))
        collectionViewItemData.append(HomeCollectionViewCardCellDataModel(with: .viewStatement))
    }
    
    private func setupDataForEnglish() {
        collectionViewItemData.append(HomeCollectionViewCardCellDataModel(with: .redemption))
        collectionViewItemData.append(HomeCollectionViewCardCellDataModel(with: .viewStatement))
        collectionViewItemData.append(HomeCollectionViewCardCellDataModel(with: .nrlpBenefits))
    }
    
    override func didTapItem(at index: Int) {
        let model = getItem(at: index)
        switch model.cardType {
        case .loyalty:
            return
            // super.didTapItem(at: index)
        case .viewStatement:
            router.navigateToViewStatement(userModel: userModel)
        case .nrlpBenefits:
            router.navigateToNRLPBenefits()
        case .redemption:
            super.didTapItem(at: index)
        default:
            break
        }
    }
    
    deinit {
        print("I am getting deinit \(String(describing: self))")
    }
}

//
//  HomeCollectionViewDataModel.swift
//  1Link-NRLP
//
//  Created by VenD on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

protocol HomeCollectionViewCellDataModelProtocol {
    var cellIdentifier: String { get set }
    var actionTitle: String { get }
    var cardType: HomeCellCardType { get set }
    var cellSize: HomeCollectionViewCellSize { get }
}

enum HomeCollectionViewCellSize {
    case full
    case half

    func getCellWidth() -> Double {
        switch self {
        case .full:
            return Double(CommonDimens.screenWidth) - 32
        case .half:
            return Double(CommonDimens.screenWidth / 2) - 24
        }
    }

    func getCellHeight() -> Double {
        switch self {
        case .full:
            return 152
        case .half:
            return getCellWidth() * (165/163)
        }
    }
}

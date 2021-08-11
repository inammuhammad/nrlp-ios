//
//  HomeCollectionViewCardCellDataModel.swift
//  1Link-NRLP
//
//  Created by VenD on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import UIKit

struct HomeCollectionViewCardCellDataModel: HomeCollectionViewCellDataModelProtocol {
    var cellSize: HomeCollectionViewCellSize = .half
    var cellIdentifier: String = "HomeCollectionViewCardCell"

    var cardType: HomeCellCardType

    var actionTitle: String {
        return cardType.getTitle()
    }
    var titleImage: UIImage {
        return cardType.getSectionImage()
    }

    init(with cardType: HomeCellCardType) {
        self.cardType = cardType
    }
}

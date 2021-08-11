//
//  PartnerMock.swift
//  NRLPTests
//
//  Created by VenD on 18/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

func getMockPartner() -> Partner {
    Partner(id: 1, partnerName: "Nadra", categories: [getMockCategory()])
}

func getMockCategory() -> NRLP.Category {
    NRLP.Category(id: 1, categoryName: "Service", pointsAssigned: 1234)
}

func getNRLPPartners() -> NRLPPartners {
    NRLPPartners(name: "NAdra", imageSrc: "img", id: 1)
}

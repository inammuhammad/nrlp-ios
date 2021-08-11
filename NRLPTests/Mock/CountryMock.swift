//
//  CountryMock.swift
//  NRLPTests
//
//  Created by VenD on 21/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

func getMockCountry() -> Country {
    Country(code: "+92", country: "Pakistan", length: 10, id: 1, createdAt: "", updatedAt: "", isActive: 1, isDeleted: 0)
}

//
//  BeneficiaryMock.swift
//  NRLPTests
//
//  Created by VenD on 18/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

func getMockBeneficiary() -> BeneficiaryModel {
    BeneficiaryModel(alias: "Test", beneficiaryId: 1234, isActive: 1, mobileNo: "03428031559", nicNicop: 1, createdAt: "", updatedAt: "", isDeleted: 0)
}

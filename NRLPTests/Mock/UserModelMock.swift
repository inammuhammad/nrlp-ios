//
//  UserModelMock.swift
//  NRLPTests
//
//  Created by VenD on 14/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

func getMockUser() -> UserModel {
    
    var commonUserModel = UserModel()
    commonUserModel.cnicNicop = 1234512345671
    commonUserModel.fullName = "Aqib"
    commonUserModel.points = "1234.45"
    commonUserModel.mobileNo = "+923215878488"
    commonUserModel.id = 1
    commonUserModel.email = "aqib@test.com"
    commonUserModel.loyaltyType = "bronze"
    commonUserModel.type = "remitter"
    commonUserModel.createdAt = ""
    commonUserModel.updatedAt = ""
    commonUserModel.isActive = 1
    commonUserModel.isDeleted = 0
    
    return commonUserModel
}

func getRegisterRequestMock(mobileNumber: String = "+92312312312") -> RegisterRequestModel {
    
    RegisterRequestModel(accountType: "remitter", cnicNicop: "42201331232131", email: "rahim@gmail.com", fullName: "Rahim", mobileNo: mobileNumber, paassword: "Abc@12345", registrationCode: "abc1235", transactionAmount: "123", transactionRefNo: "123455")
}

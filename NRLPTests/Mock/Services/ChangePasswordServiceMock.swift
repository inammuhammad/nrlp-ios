//
//  ChangePasswordServiceMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 27/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class ChangePasswordServiceMock: ChangePasswordServiceProtocol {
    func changePassword(requestModel: ChangePasswordRequestModel, responseHandler: @escaping ChangePasswordCallBack) {
        responseHandler(.success(ChangePasswordResponseModel(message: "You have successfully updated your password.")))
    }
}

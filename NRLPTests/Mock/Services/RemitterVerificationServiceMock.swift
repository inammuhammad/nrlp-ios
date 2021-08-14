//
//  RemitterVerificationServiceMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 28/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class RemitterVerificationServicePositiveMock: RemitterVerificationServiceProtocol {

    func verifyCode(requestModel: VerifyReferenceNumberRequestModel, completion: @escaping VerifyReferenceNumberCallBack) {
        completion(.success(VerifyReferenceNumberResponseModel(message: "Remitter verified successfully")))
    }
}

class RemitterVerificationServiceNegativeMock: RemitterVerificationServiceProtocol {

    func verifyCode(requestModel: VerifyReferenceNumberRequestModel, completion: @escaping VerifyReferenceNumberCallBack) {
        completion(.failure(.internetOffline))
    }
}

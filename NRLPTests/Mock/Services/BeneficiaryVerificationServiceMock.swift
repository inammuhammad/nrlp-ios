//
//  BeneficiaryVerificationService.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class BeneficiaryVerificationServicePositiveMock: BeneficiaryVerificationServiceProtocol {
    
    func verifyCode(requestModel: VerifyRegistrationCodeRequestModel, completion: @escaping VerifyBeneficiaryCodeCallBack) {
        completion(.success(VerifyRegistrationCodeResponseModel(message: "Beneficiary verified successfully")))
    }
}

class BeneficiaryVerificationServiceNegativeMock: BeneficiaryVerificationServiceProtocol {
    
    func verifyCode(requestModel: VerifyRegistrationCodeRequestModel, completion: @escaping VerifyBeneficiaryCodeCallBack) {
        completion(.failure(.internetOffline))
    }
}


//
//  BeneficiaryVerificationService.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 07/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias VerifyBeneficiaryCodeCallBack = (Result<VerifyRegistrationCodeResponseModel, APIResponseError>) -> Void

protocol BeneficiaryVerificationServiceProtocol {

    func verifyCode(requestModel: VerifyRegistrationCodeRequestModel, completion: @escaping VerifyBeneficiaryCodeCallBack)
}

class BeneficiaryVerificationService: BaseDataStore, BeneficiaryVerificationServiceProtocol {

    func verifyCode(requestModel: VerifyRegistrationCodeRequestModel, completion: @escaping VerifyBeneficiaryCodeCallBack) {

        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }

        //      Success Case
         //       completion(.success(VerifyRegistrationCodeResponseModel(message: "Beneficiary verified successfully")))

        // request building
        let request = RequestBuilder(path: .init(endPoint: .beneficiaryVerification), parameters: requestModel)

        networking.post(request: request) { (response: APIResponse<VerifyRegistrationCodeResponseModel>) in

            completion(response.result)
        }

    }

}

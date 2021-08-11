//
//  ManageBeneficiaryService.swift
//  1Link-NRLP
//
//  Created by Aqib Bangash on 08/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

typealias ManageBeneficiaryCallBack = (Result<ManageBeneficiaryResponseModel, APIResponseError>) -> Void
typealias AddBeneficiaryCallBack = (Result<AddBeneficiaryResponseModel, APIResponseError>) -> Void
typealias DeleteBeneficiaryCallBack = (Result<DeleteBeneficiaryResponseModel, APIResponseError>) -> Void

protocol ManageBeneficiaryServiceProtocol {

    func fetchBeneficiaries(requestModel: ManageBeneficiaryRequestModel, completion: @escaping ManageBeneficiaryCallBack)
    func addBeneficiary(beneficiary: AddBeneficiaryRequestModel, completion: @escaping AddBeneficiaryCallBack)
    func deleteBeneficiary(beneficiary: DeleteBeneficiaryRequestModel, completion: @escaping DeleteBeneficiaryCallBack)
}

extension ManageBeneficiaryServiceProtocol {
    func fetchBeneficiaries(requestModel: ManageBeneficiaryRequestModel, completion: @escaping ManageBeneficiaryCallBack) {
        fetchBeneficiaries(requestModel: requestModel, completion: completion)
    }
}

class ManageBeneficiaryService: BaseDataStore, ManageBeneficiaryServiceProtocol {

    func deleteBeneficiary(beneficiary: DeleteBeneficiaryRequestModel, completion: @escaping DeleteBeneficiaryCallBack) {

        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }

        // request building
        let request = RequestBuilder(path: .init(endPoint: .deleteBeneficiary), parameters: beneficiary)

        networking.post(request: request) { (response: APIResponse<DeleteBeneficiaryResponseModel>) in
            completion(response.result)
        }
    }

    func addBeneficiary(beneficiary: AddBeneficiaryRequestModel, completion: @escaping AddBeneficiaryCallBack) {

        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }

        // request building
        let request = RequestBuilder(path: .init(endPoint: .addBeneficiary), parameters: beneficiary)

        networking.post(request: request) { (response: APIResponse<AddBeneficiaryResponseModel>) in

            completion(response.result)
        }
    }

    func fetchBeneficiaries(requestModel: ManageBeneficiaryRequestModel, completion: @escaping ManageBeneficiaryCallBack) {

        if !NetworkState.isConnected() {
            completion(.failure(.internetOffline))
            return
        }

        //        completion(.success(ManageBeneficiaryResponseModel(data: allBenefiaries, message: "success")))

        // request building
        let request = RequestBuilder(path: .init(endPoint: .manageBeneficiary), parameters: requestModel)

        networking.get(request: request) { (response: APIResponse<ManageBeneficiaryResponseModel>) in

            completion(response.result)
        }
    }
}

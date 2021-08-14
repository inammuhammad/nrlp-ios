//
//  ManageBeneficiaryServicesMock.swift
//  NRLPTests
//
//  Created by Aqib Bangash on 20/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class ManageBeneficiaryServicePositiveMock: ManageBeneficiaryServiceProtocol {
    
    var noBeneficiaryWorking: Bool = false
    var beneficiaryCountGreater: Bool = false
    
    func addBeneficiary(beneficiary: AddBeneficiaryRequestModel, completion: @escaping AddBeneficiaryCallBack) {
        
        completion(.success(AddBeneficiaryResponseModel(message: "Beneficiary Added Successfully")))
    }
    
    func deleteBeneficiary(beneficiary: DeleteBeneficiaryRequestModel, completion: @escaping DeleteBeneficiaryCallBack) {
        
        completion(.success(DeleteBeneficiaryResponseModel(message: "Beneficiary Deleted Successfully")))
    }
    
    func fetchBeneficiaries(requestModel: ManageBeneficiaryRequestModel, completion: @escaping ManageBeneficiaryCallBack) {
        if noBeneficiaryWorking {
            completion(.success(ManageBeneficiaryResponseModel(data: [], message: "Success")))
        } else if beneficiaryCountGreater {
            completion(.success(ManageBeneficiaryResponseModel(data: [getMockBeneficiary(),getMockBeneficiary(),getMockBeneficiary() ], message: "Success")))
        } else {
            completion(.success(ManageBeneficiaryResponseModel(data: [getMockBeneficiary()], message: "Success")))
        }
        
    }
}


class ManageBeneficiaryServiceNegativeMock: ManageBeneficiaryServiceProtocol {
    func addBeneficiary(beneficiary: AddBeneficiaryRequestModel, completion: @escaping AddBeneficiaryCallBack) {
        
        completion(.failure(.internetOffline))
    }
    
    func deleteBeneficiary(beneficiary: DeleteBeneficiaryRequestModel, completion: @escaping DeleteBeneficiaryCallBack) {
        
        completion(.failure(.internetOffline))
    }
    
    func fetchBeneficiaries(requestModel: ManageBeneficiaryRequestModel, completion: @escaping ManageBeneficiaryCallBack) {
        completion(.failure(.internetOffline))
    }
}

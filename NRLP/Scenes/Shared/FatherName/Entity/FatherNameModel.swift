//
//  FatherNameModel.swift
//  NRLP
//
//  Created by Muhammad Shahid Shakeel on 05/06/2022.
//  Copyright © 2022 Systems Ltd. All rights reserved.
//

import Foundation

struct FatherNameRequestModel: Codable {
    let fatherName: String
    
    enum CodingKeys: String, CodingKey {
        case fatherName = "father_name"
    }
}

struct FatherNameResponseModel: Codable {
    
}

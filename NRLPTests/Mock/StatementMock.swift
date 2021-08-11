//
//  StatementMock.swift
//  NRLPTests
//
//  Created by VenD on 23/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

func getMockStatementWithoutName() -> Statement {
    Statement(status: "Paid", type: "Credit", points: "1234", date: "01-01-2019", name: nil, formattedCreatedDate: "", createdDate: Date())
}

func getMockStatementWithName() -> Statement {
    Statement(status: "Paid", type: "Credit", points: "1234", date: "01-01-2019", name: "Transfer to Rahim", formattedCreatedDate: "", createdDate: Date())
}

func getMockStatementWithNormal() -> Statement {
    Statement(status: "Paid", type: "Normal", points: "1234", date: "01-01-2019", name: "Transfer to Rahim", formattedCreatedDate: "", createdDate: Date())
}

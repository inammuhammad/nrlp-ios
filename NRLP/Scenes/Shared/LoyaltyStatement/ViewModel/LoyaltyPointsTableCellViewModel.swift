//
//  LoyaltyPointsTableCellViewModel.swift
//  1Link-NRLP
//
//  Created by VenD on 12/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

struct LoyaltyPointsTableCellViewModel {
    private var statement: Statement
    
    var infoTitle: String {
        return  statement.name ?? statement.status ?? ""
    }
    
    var transactionIDTitle: String {
        return  statement.transaction_id ?? ""
    }

    
    var formattedPoints: String {
        let statementPoints = statement.points.double
        let formater = PointsFormatter()
        let formattedPoints = formater.format(string: "\(Int(statementPoints))")

        return formattedPoints
    }
    
    var isEarned: Bool {
        return statement.type == "Credit"
    }
    
    init(with statement: Statement) {
        self.statement = statement
    }
    
    mutating func getCreatedData() -> String {
        return statement.formattedCreatedDate
    }
}

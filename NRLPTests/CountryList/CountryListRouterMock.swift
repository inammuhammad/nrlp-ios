//
//  CountryListRouterMock.swift
//  NRLPTests
//
//  Created by VenD on 22/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
@testable import NRLP

class CountryListRouterMock: CountryListRouter {
    
    var didPopToPreviousScreen: Bool = false
    
    override func popToPreviousScreen() {
        didPopToPreviousScreen = true
        
        super.popToPreviousScreen()
    }
}

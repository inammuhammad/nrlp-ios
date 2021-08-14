//
//  NetworkState.swift
//  1Link-NRLP
//
//  Created by Faizan Ellahi on 09/07/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation
import Alamofire

class NetworkState {
    class func isConnected() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

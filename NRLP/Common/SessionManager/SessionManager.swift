//
//  SessionManager.swift
//  NRLP
//
//  Created by Muhammad Usman Tatla on 05/01/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation
import UIKit

protocol SessionContract {
    var sessionPolicy: SessionPolicy {get}
    func resigningActiveSatate(_ date: Date)
    func resumingActiveState(_ date: Date)
    func terminatingApplication()
    func expireSession()
}

/// SessionManager class will handle Session Management, specifically Inactivity Expiry.
class SessionManager: SessionContract {
    let sessionPolicy: SessionPolicy
    
    init(policy: SessionPolicy = SessionPolicy()) {
        self.sessionPolicy = policy
    }
    
    func resigningActiveSatate(_ date: Date) {
        NRLPUserDefaults.shared.set(inActiveDate: date)
    }
    
    func resumingActiveState(_ date: Date) {
        if let inactiveDate = NRLPUserDefaults.shared.inActiveDate, !sessionPolicy.validateSession(for: inactiveDate, against: date) {
            expireSession()
        }
        NRLPUserDefaults.shared.removeInActiveDate()
    }
    
    func terminatingApplication() {
        NRLPUserDefaults.shared.removeInActiveDate()
    }
    
    func expireSession() {
        UIApplication.shared.keyWindow?.switchRoot(withRootController: LoginModuleBuilder().build())
        NRLPUserDefaults.shared.removeMaxInActivityDuration()
    }
}

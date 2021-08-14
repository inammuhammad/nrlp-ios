//
//  SessionPolicy.swift
//  NRLP
//
//  Created by Muhammad Usman Tatla on 06/01/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

protocol MaxInActivityDurationProvider {
    var maxInActivityDurationValue: Int? {get}
}

final class SessionPolicy {
    private let calendar: Calendar
    private let provider: MaxInActivityDurationProvider
    
    init(calendar: Calendar = Calendar(identifier: .gregorian), provider: MaxInActivityDurationProvider = NRLPUserDefaults.shared) {
        self.calendar = calendar
        self.provider = provider
    }
    
    /// Validate Session checks if the current sessions should invalidate, expire in case of inactivity time or not
    /// - Parameters:
    ///   - inactiveDate: The Date when application became inactive
    ///   - resumeDate: The Date when application becomes active again
    /// - Returns: return True if the session is valid and when  maxInActiveSessionExpiry is nill otherwise returns false
    
    func validateSession(for inactiveDate: Date, against resumeDate: Date) -> Bool {
        guard let maxInActiveSessionExpiryInSeconds = provider.maxInActivityDurationValue else {return true}
        guard let maxInExpiryDate = calendar.date(byAdding: .second, value: maxInActiveSessionExpiryInSeconds, to: inactiveDate) else {
            return false
        }
        return resumeDate < maxInExpiryDate
    }
    
}

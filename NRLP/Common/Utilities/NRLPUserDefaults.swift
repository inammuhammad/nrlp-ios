//
//  NRLPUserDefaults.swift
//  1Link-NRLP
//
//  Created by VenD on 11/08/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import Foundation

class NRLPUserDefaults {
    
    enum UserDefaultKeys: String {
        case language
        case inActiveDate
        case maxInActiveDuration
        case maxBeneficiariesAllowed
    }
    
    static let shared = NRLPUserDefaults()
    
    private var userDefaults: UserDefaults
    
    private(set) var cachedSelectedLanguage: AppLanguage?
    private(set) var inActiveDate: Date?
    private(set) var maxInActivityDuration: Int?
    private(set) var maxBeneficiariesAllowed: Int?
    
    init (userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        self.cachedSelectedLanguage = getSelectedLanguage()
        self.inActiveDate = getInActiveDate()
    }
    
    func getSelectedLanguage() -> AppLanguage? {
        let selectedLanguage = userDefaults.string(forKey: UserDefaultKeys.language.rawValue)
        return AppLanguage(rawValue: selectedLanguage ?? "")
    }
    
    func set(selectedLanguage: AppLanguage) {
        self.cachedSelectedLanguage = selectedLanguage
        userDefaults.set(selectedLanguage.rawValue, forKey: UserDefaultKeys.language.rawValue)
    }
    
    func removeSelectedLanguage() {
        self.cachedSelectedLanguage = nil
        userDefaults.removeObject(forKey: UserDefaultKeys.language.rawValue)
    }
    
    func getInActiveDate() -> Date? {
        return userDefaults.object(forKey: UserDefaultKeys.inActiveDate.rawValue) as? Date
    }
    
    func set(inActiveDate: Date) {
        self.inActiveDate = inActiveDate
        userDefaults.set(inActiveDate, forKey: UserDefaultKeys.inActiveDate.rawValue)
    }
    
    func removeInActiveDate() {
        self.inActiveDate = nil
        userDefaults.removeObject(forKey: UserDefaultKeys.inActiveDate.rawValue)
    }
    
    func getMaxInActivityDuration() -> Int? {
        return userDefaults.object(forKey: UserDefaultKeys.maxInActiveDuration.rawValue) as? Int
    }
    
    func setMaxInActivityDuration(duration: Int) {
        self.maxInActivityDuration = duration
        userDefaults.set(maxInActivityDuration, forKey: UserDefaultKeys.maxInActiveDuration.rawValue)
    }
    
    func removeMaxInActivityDuration() {
        self.maxInActivityDuration = nil
        userDefaults.removeObject(forKey: UserDefaultKeys.maxInActiveDuration.rawValue)
    }
    
    func getMaxBeneficiariesAllowed() -> Int? {
        return userDefaults.object(forKey: UserDefaultKeys.maxBeneficiariesAllowed.rawValue) as? Int
    }
    
    func setMaxBeneficiariesAllowed(number: Int) {
        self.maxBeneficiariesAllowed = number
        userDefaults.set(maxBeneficiariesAllowed, forKey: UserDefaultKeys.maxBeneficiariesAllowed.rawValue)
    }
    
    func removeMaxBeneficiariesAllowed() {
        self.maxBeneficiariesAllowed = nil
        userDefaults.removeObject(forKey: UserDefaultKeys.maxBeneficiariesAllowed.rawValue)
    }
}

extension NRLPUserDefaults: MaxInActivityDurationProvider {
    var maxInActivityDurationValue: Int? {
        return getMaxInActivityDuration()
    }
}

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
    }
    
    static let shared = NRLPUserDefaults()
    
    private var userDefaults: UserDefaults
    
    private(set) var cachedSelectedLanguage: AppLanguage?
    
    init (userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        self.cachedSelectedLanguage = getSelectedLanguage()
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
}

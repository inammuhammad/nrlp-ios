//
//  Date+Extensions.swift
//  NRLP
//
//  Created by Muhammad Usman Tatla on 15/02/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

extension Date {
    func minutes() -> String {
        self.get(.minute)
    }
    
    func seconds() -> String {
        self.get(.second)
    }
    
    func hours() -> String {
        self.get(.hour)
    }
    
    func months() -> String {
        self.get(.month)
    }
    
    func firstCenturyCharacter() -> String {
        String(self.get(.year).prefix(1))
    }
    
    func  last2CenturyCharacters() -> String {
        String(self.get(.year).suffix(2))
    }
    
    private func get(_ type: Calendar.Component) -> String {
        let calendar = Calendar.current
        let t = calendar.component(type, from: self)
        return (t < 10 ? "0\(t)" : t.description)
    }
    
    func adding(seconds: Int) -> Date? {
        return Calendar.current.date(byAdding: .second, value: seconds, to: self)
    }
    
    func adding(minutes: Int) -> Date? {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)
    }
    
    func adding(hours: Int) -> Date? {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self)
    }
}

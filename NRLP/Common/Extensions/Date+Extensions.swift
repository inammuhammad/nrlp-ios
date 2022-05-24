//
//  Date+Extensions.swift
//  NRLP
//
//  Created by Muhammad Usman Tatla on 15/02/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

extension Date {
    var local: Date? {
        let offset = TimeZone.current.secondsFromGMT()
        return Calendar.current.date(byAdding: .second, value: offset, to: self)
    }
    
    var yesterday: Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
    
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
    
    func day() -> String {
        self.get(.day)
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
    
    func adding(days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: self)
    }
}

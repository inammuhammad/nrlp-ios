//
//  RequestKeyGenerator.swift
//  NRLP
//
//  Created by Muhammad Usman Tatla on 11/02/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import Foundation

final class RequestKeyGenerator {
    
    // Request Key Generator is singelton. The only purpose of the class is to generate 32 digit random key
    private init() {}
    
    private static var randomNumber: String?
    private static var currentCNIC: String?
    private static var currentAccountType: AccountType?
    
    static func get32DigitsKey(cnic: String, accountType: AccountType, ipAddress: String = IPAddressManager.getIPAddress(), date: Date = Date()) -> String? {
        if randomNumber == nil || currentCNIC != cnic || accountType != currentAccountType {
            currentCNIC = cnic
            currentAccountType = accountType
            randomNumber = generateWith(cnic: cnic, ipAddress: ipAddress, date: date)
        }
        return randomNumber
    }
    
    static func sameCNIC(cnic: String) -> Bool {
        return currentCNIC == cnic
    }
    
    static func sameAccountType(type: AccountType) -> Bool {
        return currentAccountType == type
    }
    
    static func reset() {
        randomNumber = nil
        currentCNIC = nil
    }
    
    /*
     Character   1-2 : CNIC 13th & 12th digits
     Character   3-4 : Time Seconds
     Character   5-6 : IP Last 2 Bytes of 4th octets
     Character   7-8 : CNIC 11th & 10th digits
     Character  9-10 : Time Minutes
     Character 11-12 : IP Last 2 Bytes of 3rd octets
     Character 13-14 : CNIC 9th & 8th digits
     Character 15-16 : Time Hour
     Character 17-18 : IP Last 2 Bytes of 2nd octets
     Character 19-20 : CNIC 7th & 6th digits
     Character 21-22 : Date Year last 2 bytes
     Character 23-24 : IP Last 2 Bytes of 1st octets
     Character 25-26 : CNIC 5th & 4th digits
     Character 27-28 : Date Month
     Character 29-30-31 : CNIC 3rd & 2nd & 1st digits
     Character 32 : Date Year first byte
     */
    
    private static func generateWith(cnic: String, ipAddress: String, date: Date) -> String? {
        guard cnic.count >= 13, ipAddress.count >= 19 else {return nil}
        let splits = ipAddress.split(separator: ".")
        let digits_1_2 = cnic.stringFromIndices(12, 11)
        let digits_3_4 = date.seconds()
        let digits_5_6 = String(splits[3]).stringSuffix(2)
        let digits_7_8 = cnic.stringFromIndices(10, 9)
        let digits_9_10 = date.minutes()
        let digits_11_12 = String(splits[2]).stringSuffix(2)
        let digits_13_14 = cnic.stringFromIndices(8, 7)
        let digits_15_16 = date.hours()
        let digits_17_18 = String(splits[1]).stringSuffix(2)
        let digits_19_20 = cnic.stringFromIndices(6, 5)
        let digits_21_22 = date.last2CenturyCharacters()
        let digits_23_24 = String(splits[0]).stringSuffix(2)
        let digits_25_26 = cnic.stringFromIndices(4, 3)
        let digits_27_28 = date.months()
        let digits_29_30_31 = cnic.stringFromIndices(2, 1, 0)
        let digit_32 = date.firstCenturyCharacter()
        
        return digits_1_2 + digits_3_4 + digits_5_6 + digits_7_8 + digits_9_10 + digits_11_12 + digits_13_14 + digits_15_16 + digits_17_18 + digits_19_20 + digits_21_22 + digits_23_24 + digits_25_26 + digits_27_28 + digits_29_30_31 + digit_32
    }
}

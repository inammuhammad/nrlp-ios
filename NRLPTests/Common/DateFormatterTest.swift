//
//  DateFormatterTest.swift
//  NRLPTests
//
//  Created by VenD on 14/09/2020.
//  Copyright © 2020 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class DateFormatterTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDaySuffix() {
        var date = DateFormat().formatDate(dateString: "20200101", formatter: .advanceStatementFormat)
        XCTAssertEqual(date?.daySuffix() ?? "", "st")
        
        date = DateFormat().formatDate(dateString: "20200102", formatter: .advanceStatementFormat)
        XCTAssertEqual(date?.daySuffix() ?? "", "nd")
        
        date = DateFormat().formatDate(dateString: "20200103", formatter: .advanceStatementFormat)
        XCTAssertEqual(date?.daySuffix() ?? "", "rd")
        
        date = DateFormat().formatDate(dateString: "20200121", formatter: .advanceStatementFormat)
        XCTAssertEqual(date?.daySuffix() ?? "", "st")
        
        date = DateFormat().formatDate(dateString: "20200131", formatter: .advanceStatementFormat)
        XCTAssertEqual(date?.daySuffix() ?? "", "st")
        
        date = DateFormat().formatDate(dateString: "20200122", formatter: .advanceStatementFormat)
        XCTAssertEqual(date?.daySuffix() ?? "", "nd")
        
        date = DateFormat().formatDate(dateString: "20200123", formatter: .advanceStatementFormat)
        XCTAssertEqual(date?.daySuffix() ?? "", "rd")
        
        date = DateFormat().formatDate(dateString: "20200111", formatter: .advanceStatementFormat)
        XCTAssertEqual(date?.daySuffix() ?? "", "th")
        
        date = DateFormat().formatDate(dateString: "20200130", formatter: .advanceStatementFormat)
        XCTAssertEqual(date?.daySuffix() ?? "", "th")
    }
    
    func testDateFormatWithSuffix() {
        var date = DateFormat().formatDate(dateString: "20200101", formatter: .advanceStatementFormat)
        XCTAssertEqual(DateFormat().formatDateString(to: date, formatter: .daySuffixFullMonth) ?? "", "01st January 2020")
        
        date = DateFormat().formatDate(dateString: "20200102", formatter: .advanceStatementFormat)
        XCTAssertEqual(DateFormat().formatDateString(to: date, formatter: .daySuffixFullMonth) ?? "", "02nd January 2020")
        
        date = DateFormat().formatDate(dateString: "20200103", formatter: .advanceStatementFormat)
        XCTAssertEqual(DateFormat().formatDateString(to: date, formatter: .daySuffixFullMonth) ?? "", "03rd January 2020")
        
        date = DateFormat().formatDate(dateString: "20200121", formatter: .advanceStatementFormat)
        XCTAssertEqual(DateFormat().formatDateString(to: date, formatter: .daySuffixFullMonth) ?? "", "21st January 2020")
        
        date = DateFormat().formatDate(dateString: "20200131", formatter: .advanceStatementFormat)
        XCTAssertEqual(DateFormat().formatDateString(to: date, formatter: .daySuffixFullMonth) ?? "", "31st January 2020")
        
        date = DateFormat().formatDate(dateString: "20200122", formatter: .advanceStatementFormat)
        XCTAssertEqual(DateFormat().formatDateString(to: date, formatter: .daySuffixFullMonth) ?? "", "22nd January 2020")
        
        date = DateFormat().formatDate(dateString: "20200123", formatter: .advanceStatementFormat)
        XCTAssertEqual(DateFormat().formatDateString(to: date, formatter: .daySuffixFullMonth) ?? "", "23rd January 2020")
        
        date = DateFormat().formatDate(dateString: "20200111", formatter: .advanceStatementFormat)
        XCTAssertEqual(DateFormat().formatDateString(to: date, formatter: .daySuffixFullMonth) ?? "", "11th January 2020")
        
        date = DateFormat().formatDate(dateString: "20200130", formatter: .advanceStatementFormat)
        XCTAssertEqual(DateFormat().formatDateString(to: date, formatter: .daySuffixFullMonth) ?? "", "30th January 2020")
        
        date = DateFormat().formatDate(dateString: "20200130", formatter: .advanceStatementFormat)
        XCTAssertEqual(DateFormat().formatDateString(to: date, formatter: .dateTimeMilis) ?? "", "2020-01-30T00:00:00.000Z")
        
        date = DateFormat().formatDate(dateString: "20200130", formatter: .advanceStatementFormat)
        XCTAssertEqual(DateFormat().formatDateString(to: date, formatter: .pickerFormat) ?? "", "30 January 2020")
        
        date = DateFormat().formatDate(dateString: "20200130", formatter: .advanceStatementFormat)
        XCTAssertEqual(DateFormat().formatDateString(to: date, formatter: .advanceStatementFormat) ?? "", "20200130")
    }
    
    func testFormatDateStringToAndFrom() {
        let date = DateFormat().formatDateString(dateString: "20200101", fromFormat: .advanceStatementFormat, toFormat: .daySuffixFullMonth) ?? ""
        XCTAssertEqual(date, "01st January 2020")
    }
    
    func testFormatDateString() {
        
        let date = DateFormat().formatDate(dateString: "20200101", formatter: .advanceStatementFormat)
        
        let dateString = DateFormat().formatDateString(to: date, formatter: .advanceStatementFormat)
        XCTAssertEqual(dateString, "20200101")
    }
    
    func testFormatDateStringNegative() {
        
        let dateString = DateFormat().formatDateString(to: nil, formatter: .dateTimeMilis)
        XCTAssertNil(dateString)
    }
}

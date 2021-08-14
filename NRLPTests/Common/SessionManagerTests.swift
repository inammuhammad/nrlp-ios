//
//  SessionManagerTests.swift
//  NRLPTests
//
//  Created by Muhammad Usman Tatla on 05/01/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class SessionManagerTests: XCTestCase {
    
    override func setUp() {
        removeSideEffects()
    }
    
    override func tearDown() {
        removeSideEffects()
    }

    func testSessionDoesNotExpireOnItsOwn() {
        let (sut, _) = makeSUT()
        XCTAssertEqual(sut.expiryCount, 0, "Expected Session to does not expire on intialization")
    }
    
    func testSessionInActivitySavesTime() {
        let (sut, date) = makeSUT()
        
        sut.resigningActiveSatate(date)
        
        XCTAssertEqual(NRLPUserDefaults.shared.getInActiveDate(), date, "Saved time in UserDefaults must be same as inactive time")
    }
    
    func testResumingSessionWithinExpiryTimeClearsInActiveSavedTime() {
        let (sut, date) = makeSUT()
        
        sut.resigningActiveSatate(date)
        
        sut.resumingActiveState(date.dateByAdding(second: 1))
        XCTAssertNil(NRLPUserDefaults.shared.getInActiveDate(), "Expected Inactive time to be cleared on Resuming within time")
    }
    
    
    func testResumingSessionWithinExpiryTimeDoesNotExpireSession() {
        let (sut, date) = makeSUT()
        
        sut.resigningActiveSatate(date)
        sut.resumingActiveState(date.dateByAdding(second: 1))
        
        XCTAssertNil(NRLPUserDefaults.shared.getInActiveDate())
        XCTAssertEqual(sut.expiryCount, 0, "Eprected Session to not expire, as session was resumed withit time")
    }
    
    func testResumingSessionAfterExpiryTimeExpiresSession() {
        let (sut, date) = makeSUT()
        
        sut.resigningActiveSatate(date)
        sut.resumingActiveState(date.dateByAdding(second: 3))
        
        XCTAssertNil(NRLPUserDefaults.shared.getInActiveDate())
        XCTAssertEqual(sut.expiryCount, 1, "Eprected Session to  expire, as session was resumed after time")
    }
    
    func testTerminatingAppShouldClearInActiveDate() {
        let (sut, date) = makeSUT()
        
        sut.resigningActiveSatate(date)
        sut.terminatingApplication()
        
        XCTAssertNil(NRLPUserDefaults.shared.getInActiveDate(), "Expected Inactive time to be removed on termination application")
    }
    
    // MARK: - Private Helpers
    
    func makeSUT(expiryTime seconds: Int = 2) -> (SessionManagerSpy, Date) {
        return (SessionManagerSpy(policy: SessionPolicy(provider: MockMaxInActivityProvider())), Date())
    }
    
    func removeSideEffects() {
        NRLPUserDefaults.shared.removeInActiveDate()
    }
    
    class SessionManagerSpy: SessionManager {
        var expiryCount = 0
        
        override func expireSession() {
            expiryCount += 1
        }
    }
    
    struct MockMaxInActivityProvider: MaxInActivityDurationProvider {
        var maxInActivityDurationValue: Int? {return 2}
    }
    
}

private extension Date {
    func dateByAdding(second: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(byAdding: .second, value: second, to: self)!
    }
}

//
//  AES256EncryptDecryptTests.swift
//  NRLPTests
//
//  Created by Muhammad Usman Tatla on 06/01/2021.
//  Copyright © 2021 VentureDive. All rights reserved.
//

import XCTest
@testable import NRLP

class AES256EncryptDecryptTests: XCTestCase {

    func testAES256EncryptionsAndDecryptions() {
        let testString1 = "hello world"
        let testString2 = "Hi there i am usman"
        let testString3 = "hello world How are You, My Name is Aleem Azhar"
        
        do {
            let aes = try AES256(key: "AAAABBBBCCCCDDDDAAAABBBBCCCCDDDD", iv: "AAAABBBBCCCCDDDD")
            
            let encrypted1 = try aes.encryptedString(for: testString1)
            let encrypted2 = try aes.encryptedString(for: testString2)
            let encrypted3 = try aes.encryptedString(for: testString3)
            
            XCTAssertEqual(encrypted1, "2ucA5kfOYmIWuzW-Lyesfg==")
            XCTAssertEqual(encrypted2, "m-rP2DlJb-qD6gF4DXYJDSiIhqSv1CzJaQuCcC28vUo=")
            XCTAssertEqual(encrypted3, "-W1XmFNSmBC2Xx7vvkhSoP80PZEB8NtRG_SlazLQuVComkEwDrkMwBUwDN68X6bE")
            
            let decrypted1 = try aes.decrypedtString(for: encrypted1)
            let decrypted2 = try aes.decrypedtString(for: encrypted2)
            let decrypted3 = try aes.decrypedtString(for: encrypted3)
            
            XCTAssertEqual(decrypted1, testString1)
            XCTAssertEqual(decrypted2, testString2)
            XCTAssertEqual(decrypted3, testString3)
            
        }
        catch {
            XCTFail("Expected AES256 to suceessfully encrypt and decrypt strings")
        }
        
    }

}

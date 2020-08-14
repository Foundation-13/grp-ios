//
//  DiskTests.swift
//  BatchUploaderTests
//
//  Created by Eugen Fedchenko on 14.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import XCTest
@testable import BatchUploader

class StorageTests: XCTestCase {

    func testFolders() throws {
        performTest {
            let stg = Storage()
            
            try stg.makeFolder(path: "/uploads/123")
            XCTAssertTrue(stg.isObjectExists(path: "/uploads/123"))
            
            try stg.removeObject(path: "uploads/123")
            XCTAssertFalse(stg.isObjectExists(path: "/uploads/123"))
        }
    }
    
    func testFiles() throws {
        performTest {
            let stg = Storage()
            
            try stg.makeFolder(path: "/uploads/123")
            
            let data = "data string".data(using: .utf8)!
            
            try stg.writeFile(path: "/uploads/123/0.dat", data: data)
            XCTAssertTrue(stg.isObjectExists(path: "/uploads/123/0.dat"))
            
            let read = try stg.readFile(path: "/uploads/123/0.dat")
            XCTAssertEqual(data, read)
            
            try stg.removeObject(path: "/uploads/123/0.dat")
            XCTAssertFalse(stg.isObjectExists(path: "/uploads/123/0.dat"))
            
            try stg.removeObject(path: "uploads/123")
        }
    }

    func performTest(_ closure: () throws -> Void) {
        do {
            try closure()
        } catch let err {
            XCTFail("failed with exception: \(err)")
        }
    }

}

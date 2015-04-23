//
//  FillioTestUpload.swift
//  Fillio
//
//  Created by Kévin MACHADO on 23/04/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import UIKit
import XCTest
import Fillio

class FillioTestUpload: XCTestCase {

    let params = ["action":"test", "username":"Kevin", "id": 12.2]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testUpload() {
        var expectation = self.expectationWithDescription("Test Block")
        var client = FIONetwork.clientWithRootUrl("http://localhost:9999/")
        
        client.get(params, path: "xctest/network").resume().blocks.Success {
            (let response) -> () in
            println(response.string)
            XCTAssertNotNil(response.string, "La réponse est nulle")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }

}

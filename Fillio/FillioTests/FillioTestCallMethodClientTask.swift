//
//  FillioTestCallMethodClientTask.swift
//  Fillio
//
//  Created by Kévin MACHADO on 30/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import UIKit
import XCTest
import Fillio

class FillioTestCallMethodClientTask: XCTestCase {

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
    
    func testGetDataOutsideHandler() {
        var client = FIONetwork.defaultClient
        var expectation = self.expectationWithDescription("Request session")
        var task = client["http://www.google.fr"](nil, nil)
        task.blocks.Complete {
            println("Response ->\($0)")
            println("Error -> \($1)")
            expectation.fulfill()
        }
        task.resume()
        waitForExpectationsWithTimeout(8.0, handler: nil)
    }
    
    func testGetDataInsideHandler() {
        var client = FIONetwork.defaultClient
        var expectation = self.expectationWithDescription("Google Request")
        var task = client["http://www.google.fr"](nil) {
            println("Response ->\($0)")
            println("Error -> \($1)")
            expectation.fulfill()
        }
        task.resume()
        waitForExpectationsWithTimeout(8.0, handler: nil)
    }
    
    func testTaskAutoStart() {
        var client = FIONetwork.defaultClient
        client.config.autostartTask = true
        var expectation = self.expectationWithDescription("Google Request")
        var task = client["http://www.google.fr"](nil) {
            expectation.fulfill()
            println("Response ->\($0)")
            println("Error -> \($1)")
        }
        waitForExpectationsWithTimeout(9.0, handler: nil)
    }

}

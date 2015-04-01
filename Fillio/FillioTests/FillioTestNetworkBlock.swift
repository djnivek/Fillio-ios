//
//  FillioTestNetworkBlock.swift
//  Fillio
//
//  Created by Kévin MACHADO on 31/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import UIKit
import XCTest
import Fillio

class FillioTestNetworkBlock: XCTestCase {

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
    
    func testErrorBlock() {
        var api = FIONetwork.clientWithRootUrl("http://invalid.url")
        api.config.autostartTask = true
        api.config.sessionType = FIONetworkHTTPSessionType.EphemeralSession
        var expectation = self.expectationWithDescription("Invalid url error block")
        var task = api["/user/1"]("", nil)
        task.blocks.Fail {
            (let error) in
            println("The error is '\(error)'")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testSuccessBlock() {
        var api = FIONetwork.clientWithRootUrl("http://www.google.fr")
        api.config.autostartTask = true
        api.config.sessionType = FIONetworkHTTPSessionType.EphemeralSession
        var expectation = self.expectationWithDescription("Valid url success block")
        var task = api[""]("", nil)
        task.blocks.Fail {
            (let error) in
            println("Error -> \(error)")
        }
        task.blocks.Success {
            (let response, let data) in
            println("The response is '\(response)'")
            println("The data is '\(data)'")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testCompleteBlock() {
        var api = FIONetwork.clientWithRootUrl("http://www.google.fr")
        api.config.autostartTask = true
        api.config.sessionType = FIONetworkHTTPSessionType.EphemeralSession
        var expectation = self.expectationWithDescription("Valid url success block")
        var task = api[""]("", nil)
        task.blocks.Complete {
            (let response, let data, let error) in
            println("The response is '\(response)'")
            println("The data is '\(data)'")
            println("The error is '\(error)'")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testDoubleCompleteBlock() {
        var api = FIONetwork.clientWithRootUrl("http://www.google.fr")
        api.config.autostartTask = true
        api.config.sessionType = FIONetworkHTTPSessionType.EphemeralSession
        var expectation = self.expectationWithDescription("Valid url success block")
        
        var task = api[""]("") {
            (let response, let data, let error) in
            println("The response is '\(response)'")
            println("The data is '\(data)'")
            println("The error is '\(error)'")
            //expectation.fulfill()
        }
        
        task.blocks.Complete {
            (let response, let data, let error) in
            println("The response is '\(response)'")
            println("The data is '\(data)'")
            println("The error is '\(error)'")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }

}

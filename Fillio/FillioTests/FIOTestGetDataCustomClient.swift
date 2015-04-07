//
//  FIOTestGetDataCustomClient.swift
//  Fillio
//
//  Created by Kévin MACHADO on 30/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import UIKit
import XCTest
import Fillio

class FIOTestGetDataCustomClient: XCTestCase {

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
    
    func testGetDataFromAPI() {
        var api = FIONetwork.clientWithRootUrl("http://localhost:9999")
        api.config.autostartTask = true
        api.config.sessionType = FIONetworkHTTPSessionType.EphemeralSession
        var expectation = self.expectationWithDescription("Api Request")
        var task = api["class/user/1"]("") {
            (let resp, let error) in
            println("response -> \(resp)")
            println("error -> \(error)")
            expectation.fulfill()
        }
        
        task.blocks.Fail {
            (let error) in
            println("The error is '\(error)'")
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testGetDataFromTwitterAPI() {
        var api = FIONetwork.clientWithRootUrl("https://api.twitter.com/1.1/")
        api.config.autostartTask = true
        api.config.sessionType = FIONetworkHTTPSessionType.EphemeralSession
        var expectation = self.expectationWithDescription("Api Request")
        var task = api["search/tweets.json"]("") {
            (let resp, let error) in
            println("response -> \(resp)")
            println("error -> \(error)")
        }
        
        task.blocks.Success {
            (let response) in
            println("The response is '\(response)'")
            expectation.fulfill()
        }
        
        task.blocks.Fail {
            (let error) in
            println("The error is '\(error)'")
        }
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    


}

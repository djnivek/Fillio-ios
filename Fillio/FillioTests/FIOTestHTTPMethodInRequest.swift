//
//  FIOTestHTTPMethodInRequest.swift
//  Fillio
//
//  Created by Kévin MACHADO on 12/04/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import UIKit
import XCTest
import Fillio

class FIOTestHTTPMethodInRequest: XCTestCase {

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
    
    func testPOSTRequest() {
        // create client
        var myClient = FIONetwork.clientWithRootUrl("http://localhost:9999/")
        
        // create params
        let params = ["action":"test", "username":"Kevin", "id": 12.2]
        
        var expectation = self.expectationWithDescription("Test POST Params")
        
        //create task
        var task = myClient["xctest/network"](HTTPMethod.POST(params)) {
            (let response, let error) in
            if let rps = response?.string  {
                let action = rps
                println("test -> \(action)")
            }
            println("The response is '\(response)'")
            println("The error is '\(error)'")
            expectation.fulfill()
        }
        
        // set completion handler for the call back
        task.blocks.Success({
            (let response) in
            println("Voila c'est ça \(response.object)")
        })
        
        // start task
        task.resume()
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testGETRequest() {
        
        var myClient = FIONetwork.clientWithRootUrl("http://localhost:9999/")
        let params = ["action":"test", "username":"Kevin", "id": 12.2]
        
        var expectation = self.expectationWithDescription("Test POST Params")
        
        var task = myClient["xctest/network"](HTTPMethod.POST(params)) {
            (let response, let error) in
            println("The response is '\(response)'")
            println("The response is '\(error)'")
            expectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }

}

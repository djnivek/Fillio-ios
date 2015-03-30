//
//  FillioTests.swift
//  FillioTests
//
//  Created by Kévin MACHADO on 09/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import UIKit
import XCTest
import Fillio

class FillioTests: XCTestCase {
    
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
    
    func testNSURL() {
        var session = NSURLSession.sharedSession()
        
        var tasks = [NSURLSessionTask]()
        
        var expectation = self.expectationWithDescription("Google request")
        
        var url = NSURL(string: "http://www.google.fr")
        if let myUrl = url {
            var request = NSURLRequest(URL: myUrl)
            var dataTask: NSURLSessionDataTask?
            dataTask = session.dataTaskWithRequest(request, completionHandler: { (let data, let response, let error) -> Void in
                expectation.fulfill()
                println("response : \(response)")
                println("error : \(error)")
            })
            if let task = dataTask {
                tasks.append(task)
            }
            
            for task in tasks {
                println("State task beforeResume \(task.state == .Running)")
            }
            
            dataTask?.resume()
            
            for task in tasks {
                println("State task afterResume \(task.state == .Running)")
            }
            
            waitForExpectationsWithTimeout(5.0, handler: nil)
        }
    }
}

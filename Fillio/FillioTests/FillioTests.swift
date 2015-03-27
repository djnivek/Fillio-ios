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
    
    func testGetData() {
        var client = FIONetwork.defaultClient
        client["http://www.google.fr"]("") {
            println("Param ->\($0)")
            println("With url -> \($1)")
        }
    }
    
    func testCallApi() {
        var apiClient = FIONetwork.clientWithRootUrl("http://localhost:8888/")
        apiClient.progressHandler {
            
        }
        apiClient["user/1"]("token=2hdg2gJDek86jHudsgHGDS") {
            println("Param ->\($0)")
            println("With url -> \($1)")
        }
    }
    
    func testNSURL() {
        var session = NSURLSession.sharedSession()
        var url = NSURL(string: "http://www.google.fr")
        if let myUrl = url {
            var request = NSURLRequest(URL: myUrl)
            var dataTask: NSURLSessionDataTask?
            dataTask = session.dataTaskWithRequest(request)
        }
    }
    
    func testSetConfigHTTPClient() {
        var apiClient = FIONetwork.defaultClient
        apiClient.config.sessionType = FIONetworkHTTPSessionType.EphemeralSession
        apiClient.config.allowCellularAccess = false
    }
}

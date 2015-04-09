//
//  FIOTestsJSONParsing.swift
//  Fillio
//
//  Created by Kévin MACHADO on 08/04/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import UIKit
import XCTest
import Fillio

class FIOTestsJSONParsing: XCTestCase {

    var json: [String: AnyObject]!
    
    override func setUp() {
        super.setUp()
        let error: [String: AnyObject] = ["message": "voilà mon message", "code" : 400]
        self.json = ["error" : error]
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
    
    func testParseResultString() {
        let objParsed = FIONetworkResultObject(data: json)
        let test = objParsed["error"]["message"]
        XCTAssertNotNil(test.stringValue, "The message is nil")
        println("this is the test : '\(test.stringValue)'")
    }
    
    func testParseResultInt() {
        let objParsed = FIONetworkResultObject(data: json)
        let test = objParsed["error"]["code"]
        XCTAssertNotNil(test.numberValue, "The message is nil")
        println("this is the test : '\(test.numberValue)'")
    }
    
    func testParseResultUnknow() {
        let objParsed = FIONetworkResultObject(data: json)
        let test = objParsed["error"]["code"]
        XCTAssertNotNil(test.anyValue, "The message is nil")
        println("this is the test : '\(test.anyValue)'")
    }
    
    func testParseResultArrayNoKey() {
        let objParsed = FIONetworkResultObject(data: json)
        let theCode = objParsed["error"]["theCode"]
        
        if let val: AnyObject = theCode.anyValue {
            println(val)
        }
        
        if let theError = theCode.error {
            println(theError.description)
        }
    }

}

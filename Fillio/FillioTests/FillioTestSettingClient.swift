//
//  FillioTestSettingClient.swift
//  Fillio
//
//  Created by Kévin MACHADO on 30/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import UIKit
import XCTest
import Fillio

class FillioTestSettingClient: XCTestCase {

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
    
    func testSetConfigHTTPClient() {
        var apiClient = FIONetwork.defaultClient
        apiClient.config.sessionType = FIONetworkHTTPSessionType.EphemeralSession
        apiClient.config.allowCellularAccess = false
    }
    
    func testSetUrl() {
        var client = FIONetwork.clientWithRootUrl("http://www.google.fr")
        //XCTAssert(client.url?.absolute != nil, "L'url n'est pas définie")
    }
    
    func testSuffixForURL() {
        var s = "test/"
        XCTAssert(s.hasSuffix("/"), "The string doesn't finish with contain '/'")
    }
    
    func testInitUrl() {
        var url = NSURL(string: "http://www.google.fr/test/1.php/")
        println(url?.path)
        XCTAssert(url != nil, "L'url n'a pas été initialisée correctement")
    }

}

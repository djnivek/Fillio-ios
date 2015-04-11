//
//  FIOTestObjectAutoComplete.swift
//  Fillio
//
//  Created by Kévin MACHADO on 10/04/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import UIKit
import XCTest

class FIOTestObjectAutoComplete: XCTestCase {

    var json = [String: AnyObject]()
    
    override func setUp() {
        super.setUp()
        
        let age = 24
        let fname = "Kevin"
        let lname = "MACHADO"
        let phone = "06.19.35.37.67"
        
        let rue = "rue saint fiacre"
        let num = 11
        
        let adresse = ["number": num, "street": rue]
        
        json = ["age": age, "prenom": fname, "nom": lname, "phone": phone, "adresse": adresse]
        
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
    
    func testAutoCompleteObejct() {
        var contact: Contact = Contact(json)
        XCTAssertNotNil(contact.firstname, "Le firstname est vide")
        XCTAssertNotNil(contact.lastname, "Le lastname est vide")
        XCTAssertNotNil(contact.age, "L'age est vide")
        XCTAssertNotNil(contact.phone, "Le numéro de téléphone est vide")
        println(contact)
    }

}

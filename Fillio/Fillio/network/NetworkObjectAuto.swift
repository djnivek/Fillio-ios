//
//  FIONetworkObjectAuto.swift
//  Fillio
//
//  Created by Kévin MACHADO on 10/04/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

/*public protocol ObjectAutoProtocol {
    func Map(correspondanceMapping: [String: String])
}*/

public typealias FIODictionary = [String: AnyObject]

public class FIONetworkObjectAuto: NSObject {//: ObjectAutoProtocol {
    
    private var dictionary = FIODictionary()
    
    public init(_ data: [String: AnyObject]) {
        super.init()
        dictionary = data
        populate()
    }
    
    private func populate() {
        for key in dictionary.keys {
            self.setValue(dictionary[key], forKey: key)
        }
    }
    
    override public var description: String {
        get {
            // get all properties
            
            // OR
            
            // put the object into dictionary and print it
            return ""
        }
    }
    
}
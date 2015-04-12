//
//  FIONetworkObjectAuto.swift
//  Fillio
//
//  Created by Kévin MACHADO on 10/04/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

/// The protocol that provide mapping for object that wants to be populate
public protocol FIOObjectManualMappedProtocol {
    /// This method must return the map of your object
    ///
    /// Key must be the Data Key, value must be the Propertie name
    ///
    /// Example :
    ///
    /// 1. JSON -> ["tel":"01.12.32.34.45", "name": "Kevin"]
    ///
    /// 2. Object vars -> "phone", "name"
    ///
    /// Map must be like this ["tel":"phone", "name":"name"]
    func Map() -> [String: String]
}

public typealias FIODictionary = [String: AnyObject]?

public class FIONetworkObjectAuto: NSObject, FIOObjectManualMappedProtocol {
    
    /// The dictionary of the given data
    private var dictionary: FIODictionary = FIODictionary()
    
    /// Boolean that tells if the population must be doing automatically with auto mapping. (Set true by default)
    private var autoPopulate = true
    
    /// The initializer of the object
    ///
    /// It provide an autopopulation of the properties values
    ///
    /// :param: data Dictionary of values
    public convenience init(_ data: FIODictionary) {
        self.init(data, autoMapping: true)
    }
    
    /// The initializer of the object
    ///
    /// :param: data Dictionary of values
    /// :param: autoMapping Boolean that tells if autoMapping must be used
    public init(_ data: FIODictionary, autoMapping: Bool) {
        super.init()
        dictionary = data
        autoPopulate = autoMapping
        populate()
    }
    
}

// MARK: Auto Description

extension FIONetworkObjectAuto {
    
    override public var description: String {
        get {
            
            // get all properties and print them
            if let props = properties {
                return props.description
            }
            
            // else return an error string
            var descriptionReturn = "Error during `description` generation"
            return descriptionReturn
        }
    }
    
    /// The object's properties
    private var properties: [String: Any]? {
        /// The properties of the object, at all !
        let allProps = reflect(self)
        /// The properties filtered
        var filteredProps = [String: Any]()
        for var i = 0; i < allProps.count; i++ {
            // put values into array of filtered values
            if allProps[i].0 != "super" {
                filteredProps[allProps[i].0] = allProps[i].1.value
            }
        }
        return filteredProps
    }
    
}

// MARK: Auto Mapping

extension FIONetworkObjectAuto {
    
    /// The method that populate the object using dictionary values
    ///
    /// This method is called if `autoPopulate` is actived
    private func populate() {
        if autoPopulate {
            if let dict = dictionary {
                for key in dict.keys {
                    self.setValue(dict[key], forKey: key)
                }
            }
        }
        else {
            manualMapping()
        }
    }
    
}

// MARK: Manual Mapping

extension FIONetworkObjectAuto {
    
    public func Map() -> [String : String] {
        fatalError("Map must be overriden")
    }
    
    /// The method that populate the object with the map provided by the class
    private func manualMapping() {
        let map = self.Map()
        if let dict = dictionary {
            for key in dict.keys {
                if let mapK = map[key] {
                    self.setValue(dict[key], forKey: mapK)
                }
            }
        }
    }
    
}
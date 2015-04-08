//
//  NetworkObject.swift
//  Fillio
//
//  Created by Kévin MACHADO on 03/04/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

enum FIONetworkResultObjectType: Int {
    case Number
    case String
    case Bool
    case Array
    case Dictionary
    case Null
    case Unknown
}

struct FIONetworkResultObject {
    
    /// The attribute of the object
    private var _attribute: AnyObject
    
    private var _type: FIONetworkResultObjectType

    init(data: AnyObject) {
        self.attribute = data
    }
    
    var attribute: AnyObject {
        get {
            return _attribute
        }
        set {
            // set attribute with new value
            _attribute = newValue
            
            // set type of attribute
            switch newValue {
            case let number as NSNumber:
                if number.isBool {
                    _type = .Bool
                } else {
                    _type = .Number
                }
            case let string as NSString:
                _type = .String
            case let null as NSNull:
                _type = .Null
            case let array as [AnyObject]:
                _type = .Array
            case let dictionary as [String : AnyObject]:
                _type = .Dictionary
            }
        }
    }
}

extension FIONetworkResultObject {
    
    subscript (key: Int) -> FIONetworkResultObject {
        get {
            return attribute[key] as NSDictionary
        }
    }
    
    subscript (key: String) -> AnyObject {
        get {
            return attribute[key] as NSDictionary
        }
    }
    
}
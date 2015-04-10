//
//  NetworkObject.swift
//  Fillio
//
//  Created by Kévin MACHADO on 03/04/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

enum FIONetworkResultObjectType: Int {
    case String
    case Number
    case Array
    case Dictionary
    case Null
}

// MARK: Object -

public class FIONetworkResultObject {
    
    /// The attribute of the object
    private var _attribute: AnyObject
    
    private var _type: FIONetworkResultObjectType
    
    private var _error: NSError?

    init() {
        _attribute = NSNull()
        _type = .Null
    }
    
    public convenience init(data: AnyObject) {
        self.init()
        self.attribute = data
    }
    
    private convenience init(errorWithMessage message: String, andCode code: Int) {
        self.init()
        self._error = NSError(domain: "FillioNetworkParsingDomain", code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    public var error: NSError? {
        return self._error
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
                /*if number.isBool {
                _type = .Bool
                } else {*/
                _type = .Number
                //}
            case let string as NSString:
                _type = .String
            case let null as NSNull:
                _type = .Null
            case let array as [AnyObject]:
                _type = .Array
            case let dictionary as [String : AnyObject]:
                _type = .Dictionary
            default:
                _attribute = NSNull()
                _type = .Null
            }
        }
    }
}

// MARK: Get out value -

extension FIONetworkResultObject {
    
    public var stringValue: String? {
        return self.attribute as? String
    }
    
    public var numberValue: NSNumber? {
        return self.attribute as? NSNumber
    }
    
    public var anyValue: AnyObject? {
        return self.attribute
    }
    
}

// MARK: Printable Object -

extension FIONetworkResultObject: Printable {
    
    public var description: String {
        return self.attribute.description as String
    }
    
}


// MARK: Subscript class -

extension FIONetworkResultObject {
    
    public subscript (index: Int) -> FIONetworkResultObject {
        get {
            
            if let array = self.attribute as? [AnyObject] {
                // test array index
                if index < array.count {
                    return FIONetworkResultObject(data: array[index])
                }
            }
            
            return FIONetworkResultObject(errorWithMessage: "Out of bounds at index \(index)", andCode: 500)
            
        }
    }
    
    public subscript (key: String) -> FIONetworkResultObject {
        get {
            
            if let dictionnary = self.attribute as? [String: AnyObject] {
                // test array index
                if let item: AnyObject = dictionnary[key] {
                    return FIONetworkResultObject(data: item)
                }
            }
            
            return FIONetworkResultObject(errorWithMessage: "No entry found with key '\(key)'", andCode: 500)
        }
    }
    
}